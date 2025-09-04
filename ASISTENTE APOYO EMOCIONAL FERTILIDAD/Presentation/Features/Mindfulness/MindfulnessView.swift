import SwiftUI

struct MindfulnessView: View {
	@StateObject private var audio = AudioPlayerService()
	@State private var selectedSession: MindfulnessSession?
	@State private var sessionProgress: Double = 0
	@State private var isTimerActive = false
	@State private var remainingTime: TimeInterval = 0
	@State private var timer: Timer?
	
	private let sessions = [
		MindfulnessSession(
			id: "breathing-basic",
			title: "Respiración Básica",
			subtitle: "Técnica 4-7-8 para relajación",
			duration: 5,
			type: .breathing,
			icon: "wind",
			color: Color(hex: "#4ECDC4")
		),
		MindfulnessSession(
			id: "body-scan",
			title: "Exploración Corporal",
			subtitle: "Conecta con tu cuerpo",
			duration: 10,
			type: .bodyScan,
			icon: "figure.mind.and.body",
			color: Color(hex: "#6B73FF")
		),
		MindfulnessSession(
			id: "grounding",
			title: "Técnica de Grounding",
			subtitle: "5-4-3-2-1 para la ansiedad",
			duration: 7,
			type: .grounding,
			icon: "hand.raised.fill",
			color: Color(hex: "#FF8A95")
		),
		MindfulnessSession(
			id: "visualization",
			title: "Visualización Positiva",
			subtitle: "Imagina tu lugar seguro",
			duration: 12,
			type: .visualization,
			icon: "eye.fill",
			color: Color(hex: "#20C997")
		)
	]
	
	var body: some View {
		ScrollView {
			VStack(spacing: 24) {
				// Header
				headerSection
				
				// Current Session Player
				if let session = selectedSession {
					sessionPlayerCard(session: session)
				}
				
				// Sessions Grid
				sessionsGrid
				
				// Quick Tips
				quickTipsCard
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 8)
		}
		.background(Color(hex: "#F8F9FA"))
		.navigationTitle("mindfulness_title")
		.navigationBarTitleDisplayMode(.inline)
		.onDisappear {
			stopSession()
		}
	}
	
	// MARK: - Header Section
	private var headerSection: some View {
		ProfessionalCard {
			VStack(spacing: 12) {
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						Text("Mindfulness")
							.font(.system(size: 24, weight: .bold, design: .rounded))
							.foregroundColor(Color(hex: "#212529"))
						
						Text("Encuentra tu momento de calma")
							.font(.system(size: 16))
							.foregroundColor(Color(hex: "#6C757D"))
					}
					
					Spacer()
					
					Image(systemName: "leaf.fill")
						.font(.system(size: 32))
						.foregroundColor(Color(hex: "#4ECDC4"))
				}
			}
		}
	}
	
	// MARK: - Session Player Card
	private func sessionPlayerCard(session: MindfulnessSession) -> some View {
		ProfessionalCard {
			VStack(spacing: 20) {
				// Session Info
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						Text(session.title)
							.font(.system(size: 20, weight: .semibold))
							.foregroundColor(Color(hex: "#212529"))
						
						Text(session.subtitle)
							.font(.system(size: 14))
							.foregroundColor(Color(hex: "#6C757D"))
					}
					
					Spacer()
					
					Image(systemName: session.icon)
						.font(.system(size: 24))
						.foregroundColor(session.color)
						.frame(width: 48, height: 48)
						.background(session.color.opacity(0.1))
						.clipShape(Circle())
				}
				
				// Progress Circle
				ZStack {
					Circle()
						.stroke(Color(hex: "#E9ECEF"), lineWidth: 8)
						.frame(width: 120, height: 120)
					
					Circle()
						.trim(from: 0, to: sessionProgress)
						.stroke(session.color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
						.frame(width: 120, height: 120)
						.rotationEffect(.degrees(-90))
						.animation(.easeInOut(duration: 0.5), value: sessionProgress)
					
					VStack(spacing: 4) {
						Text(timeString(from: remainingTime))
							.font(.system(size: 20, weight: .bold, design: .monospaced))
							.foregroundColor(Color(hex: "#212529"))
						
						Text(isTimerActive ? "Restante" : "Duración")
							.font(.system(size: 12))
							.foregroundColor(Color(hex: "#6C757D"))
					}
				}
				
				// Control Buttons
				HStack(spacing: 16) {
					Button(action: {
						if isTimerActive {
							pauseSession()
						} else {
							startSession(session)
						}
					}) {
						HStack(spacing: 8) {
							Image(systemName: isTimerActive ? "pause.fill" : "play.fill")
								.font(.system(size: 16))
							
							Text(isTimerActive ? "Pausar" : "Iniciar")
								.font(.system(size: 16, weight: .semibold))
						}
						.foregroundColor(.white)
						.frame(maxWidth: .infinity)
						.frame(height: 44)
						.background(session.color)
						.clipShape(RoundedRectangle(cornerRadius: 12))
					}
					
					Button(action: stopSession) {
						Image(systemName: "stop.fill")
							.font(.system(size: 16))
							.foregroundColor(Color(hex: "#6C757D"))
							.frame(width: 44, height: 44)
							.background(Color(hex: "#F8F9FA"))
							.clipShape(Circle())
					}
					.disabled(!isTimerActive && sessionProgress == 0)
				}
			}
		}
	}
	
	// MARK: - Sessions Grid
	private var sessionsGrid: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text("Ejercicios Disponibles")
				.font(.system(size: 20, weight: .semibold))
				.foregroundColor(Color(hex: "#212529"))
			
			LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
				ForEach(sessions, id: \.id) { session in
					SessionCard(session: session) {
						selectSession(session)
					}
				}
			}
		}
	}
	
	// MARK: - Quick Tips Card
	private var quickTipsCard: some View {
		ProfessionalCard {
			VStack(alignment: .leading, spacing: 16) {
				HStack {
					Text("Consejos Rápidos")
						.font(.system(size: 18, weight: .semibold))
						.foregroundColor(Color(hex: "#212529"))
					
					Spacer()
					
					Image(systemName: "lightbulb.fill")
						.foregroundColor(Color(hex: "#FFC107"))
				}
				
				VStack(alignment: .leading, spacing: 12) {
					TipRow(
						icon: "location.fill",
						text: "Encuentra un lugar tranquilo y cómodo",
						color: Color(hex: "#4ECDC4")
					)
					
					TipRow(
						icon: "speaker.wave.2.fill",
						text: "Usa auriculares para una mejor experiencia",
						color: Color(hex: "#6B73FF")
					)
					
					TipRow(
						icon: "timer",
						text: "Practica regularmente, aunque sea por poco tiempo",
						color: Color(hex: "#FF8A95")
					)
				}
			}
		}
	}
	
	// MARK: - Helper Functions
	private func selectSession(_ session: MindfulnessSession) {
		selectedSession = session
		stopSession()
		remainingTime = TimeInterval(session.duration * 60)
		sessionProgress = 0
	}
	
	private func startSession(_ session: MindfulnessSession) {
		isTimerActive = true
		
		if remainingTime <= 0 {
			remainingTime = TimeInterval(session.duration * 60)
			sessionProgress = 0
		}
		
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
				sessionProgress = 1 - (remainingTime / TimeInterval(session.duration * 60))
			} else {
				completeSession()
			}
		}
		
		// Start audio if available
		if let audioFile = session.audioFile {
			audio.play(asset: audioFile)
		}
	}
	
	private func pauseSession() {
		isTimerActive = false
		timer?.invalidate()
		timer = nil
		audio.stop()
	}
	
	private func stopSession() {
		isTimerActive = false
		timer?.invalidate()
		timer = nil
		audio.stop()
		
		if let session = selectedSession {
			remainingTime = TimeInterval(session.duration * 60)
			sessionProgress = 0
		}
	}
	
	private func completeSession() {
		isTimerActive = false
		timer?.invalidate()
		timer = nil
		sessionProgress = 1.0
		remainingTime = 0
		
		// Show completion feedback
		let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
		impactFeedback.impactOccurred()
	}
	
	private func timeString(from timeInterval: TimeInterval) -> String {
		let minutes = Int(timeInterval) / 60
		let seconds = Int(timeInterval) % 60
		return String(format: "%d:%02d", minutes, seconds)
	}
}

// MARK: - Supporting Types and Components

struct MindfulnessSession {
	let id: String
	let title: String
	let subtitle: String
	let duration: Int // minutes
	let type: SessionType
	let icon: String
	let color: Color
	let audioFile: String?
	
	init(id: String, title: String, subtitle: String, duration: Int, type: SessionType, icon: String, color: Color, audioFile: String? = nil) {
		self.id = id
		self.title = title
		self.subtitle = subtitle
		self.duration = duration
		self.type = type
		self.icon = icon
		self.color = color
		self.audioFile = audioFile
	}
}

struct SessionCard: View {
	let session: MindfulnessSession
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 12) {
				Image(systemName: session.icon)
					.font(.system(size: 24, weight: .medium))
					.foregroundColor(session.color)
					.frame(width: 48, height: 48)
					.background(session.color.opacity(0.1))
					.clipShape(RoundedRectangle(cornerRadius: 12))
				
				VStack(spacing: 4) {
					Text(session.title)
						.font(.system(size: 14, weight: .semibold))
						.foregroundColor(Color(hex: "#212529"))
						.multilineTextAlignment(.center)
						.lineLimit(2)
					
					Text("\(session.duration) min")
						.font(.system(size: 12))
						.foregroundColor(Color(hex: "#6C757D"))
				}
			}
			.frame(maxWidth: .infinity)
			.padding(16)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 12))
			.shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct TipRow: View {
	let icon: String
	let text: String
	let color: Color
	
	var body: some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 14))
				.foregroundColor(color)
				.frame(width: 20)
			
			Text(text)
				.font(.system(size: 14))
				.foregroundColor(Color(hex: "#6C757D"))
			
			Spacer()
		}
	}
}
