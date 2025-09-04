import SwiftUI
import SwiftData
import Charts

struct MoodView: View {
	@Environment(\.modelContext) private var modelContext
	@StateObject private var orchestrator: MoodOrchestrator
	@State private var score: Int = 3
	@State private var note: String = ""
	@State private var selectedTags: Set<MoodTag> = []
	@State private var showingHistory = false
	
	init() {
		self._orchestrator = StateObject(wrappedValue: MoodOrchestrator(modelContext: ModelContext(try! ModelContainer(for: MoodEntryEntity.self))))
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 24) {
				// Header Card
				headerCard
				
				// Mood Selector
				moodSelectorCard
				
				// Tags Selector
				tagsCard
				
				// Notes Section
				notesCard
				
				// Save Button
				saveButton
				
				// Recent Entries Chart
				if !orchestrator.entries.isEmpty {
					chartCard
				}
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 8)
		}
		.background(Color(hex: "#F8F9FA"))
		.navigationTitle("mood_title")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Historial") {
					showingHistory = true
				}
			}
		}
		.sheet(isPresented: $showingHistory) {
			MoodHistoryView(entries: orchestrator.entries)
		}
		.onAppear {
			orchestrator.loadEntries()
		}
	}
	
	// MARK: - Header Card
	private var headerCard: some View {
		ProfessionalCard {
			VStack(spacing: 12) {
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						Text("¿Cómo te sientes hoy?")
							.font(.system(size: 20, weight: .semibold))
							.foregroundColor(Color(hex: "#212529"))
						
						Text("Registra tu estado emocional")
							.font(.system(size: 14))
							.foregroundColor(Color(hex: "#6C757D"))
					}
					
					Spacer()
					
					Image(systemName: "heart.circle.fill")
						.font(.system(size: 32))
						.foregroundColor(Color(hex: "#FF8A95"))
				}
			}
		}
	}
	
	// MARK: - Mood Selector Card
	private var moodSelectorCard: some View {
		ProfessionalCard {
			VStack(spacing: 20) {
				HStack {
					Text("Nivel de Ánimo")
						.font(.system(size: 18, weight: .semibold))
						.foregroundColor(Color(hex: "#212529"))
					
					Spacer()
					
					Text("\(score)")
						.font(.system(size: 24, weight: .bold, design: .rounded))
						.foregroundColor(moodColor)
						.frame(width: 40, height: 40)
						.background(moodColor.opacity(0.1))
						.clipShape(Circle())
				}
				
				// Mood Slider
				VStack(spacing: 12) {
					HStack {
						ForEach(1...5, id: \.self) { value in
							MoodButton(
								value: value,
								isSelected: score == value,
								color: colorForMood(value)
							) {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
									score = value
								}
							}
						}
					}
					
					HStack {
						Text("Muy bajo")
							.font(.system(size: 12))
							.foregroundColor(Color(hex: "#6C757D"))
						
						Spacer()
						
						Text("Excelente")
							.font(.system(size: 12))
							.foregroundColor(Color(hex: "#6C757D"))
					}
				}
			}
		}
	}
	
	// MARK: - Tags Card
	private var tagsCard: some View {
		ProfessionalCard {
			VStack(alignment: .leading, spacing: 16) {
				Text("¿Qué sientes? (Opcional)")
					.font(.system(size: 18, weight: .semibold))
					.foregroundColor(Color(hex: "#212529"))
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
					ForEach(MoodTag.allCases, id: \.self) { tag in
						TagButton(
							tag: tag,
							isSelected: selectedTags.contains(tag)
						) {
							withAnimation(.easeInOut(duration: 0.2)) {
								if selectedTags.contains(tag) {
									selectedTags.remove(tag)
								} else {
									selectedTags.insert(tag)
								}
							}
						}
					}
				}
			}
		}
	}
	
	// MARK: - Notes Card
	private var notesCard: some View {
		ProfessionalCard {
			VStack(alignment: .leading, spacing: 16) {
				Text("Notas Adicionales")
					.font(.system(size: 18, weight: .semibold))
					.foregroundColor(Color(hex: "#212529"))
				
				TextField("mood_note_placeholder", text: $note, axis: .vertical)
					.textFieldStyle(PlainTextFieldStyle())
					.font(.system(size: 16))
					.lineLimit(3...6)
					.padding(12)
					.background(Color(hex: "#F8F9FA"))
					.clipShape(RoundedRectangle(cornerRadius: 8))
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color(hex: "#E9ECEF"), lineWidth: 1)
					)
			}
		}
	}
	
	// MARK: - Save Button
	private var saveButton: some View {
		Button(action: {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
				orchestrator.recordMood(score: score, note: note.isEmpty ? nil : note, tags: Array(selectedTags))
				
				// Reset form
				note = ""
				selectedTags.removeAll()
				score = 3
			}
		}) {
			HStack {
				Image(systemName: "checkmark.circle.fill")
					.font(.system(size: 18))
				
				Text("mood_save_button")
					.font(.system(size: 16, weight: .semibold))
			}
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.frame(height: 50)
			.background(Color(hex: "#6B73FF"))
			.clipShape(RoundedRectangle(cornerRadius: 12))
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	// MARK: - Chart Card
	private var chartCard: some View {
		ProfessionalCard {
			VStack(alignment: .leading, spacing: 16) {
				Text("Tendencia Reciente")
					.font(.system(size: 18, weight: .semibold))
					.foregroundColor(Color(hex: "#212529"))
				
				Chart(orchestrator.entries.suffix(7)) { entry in
					LineMark(
						x: .value("Fecha", entry.date),
						y: .value("Puntaje", entry.score)
					)
					.foregroundStyle(Color(hex: "#6B73FF"))
					.lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
					
					AreaMark(
						x: .value("Fecha", entry.date),
						y: .value("Puntaje", entry.score)
					)
					.foregroundStyle(Color(hex: "#6B73FF").opacity(0.1))
				}
				.frame(height: 120)
				.chartYScale(domain: 1...5)
				.chartXAxis {
					AxisMarks(values: .automatic(desiredCount: 3))
				}
				.chartYAxis {
					AxisMarks(values: [1, 2, 3, 4, 5])
				}
			}
		}
	}
	
	// MARK: - Helper Properties
	private var moodColor: Color {
		colorForMood(score)
	}
	
	private func colorForMood(_ mood: Int) -> Color {
		switch mood {
		case 1: return Color(hex: "#DC3545")
		case 2: return Color(hex: "#FD7E14")
		case 3: return Color(hex: "#FFC107")
		case 4: return Color(hex: "#20C997")
		case 5: return Color(hex: "#28A745")
		default: return Color(hex: "#6C757D")
		}
	}
}

// MARK: - Supporting Components

struct ProfessionalCard<Content: View>: View {
	let content: Content
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	
	var body: some View {
		content
			.padding(16)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 12))
			.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
	}
}

struct MoodButton: View {
	let value: Int
	let isSelected: Bool
	let color: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 4) {
				Image(systemName: isSelected ? "circle.fill" : "circle")
					.font(.system(size: 24, weight: .medium))
					.foregroundColor(isSelected ? color : Color(hex: "#E9ECEF"))
				
				Text("\(value)")
					.font(.system(size: 12, weight: .medium))
					.foregroundColor(isSelected ? color : Color(hex: "#6C757D"))
			}
			.frame(maxWidth: .infinity)
			.scaleEffect(isSelected ? 1.1 : 1.0)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct TagButton: View {
	let tag: MoodTag
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Text(tag.rawValue.capitalized)
				.font(.system(size: 14, weight: .medium))
				.foregroundColor(isSelected ? .white : Color(hex: "#6C757D"))
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity)
				.background(isSelected ? Color(hex: "#6B73FF") : Color(hex: "#F8F9FA"))
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(isSelected ? Color.clear : Color(hex: "#E9ECEF"), lineWidth: 1)
				)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

// MARK: - Mood History View
struct MoodHistoryView: View {
	let entries: [MoodEntryEntity]
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationView {
			List(entries, id: \.id) { entry in
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						Text("Puntaje: \(entry.score)")
							.font(.system(size: 16, weight: .semibold))
						
						Text(entry.date, style: .date)
							.font(.system(size: 12))
							.foregroundColor(Color(hex: "#6C757D"))
						
						if let note = entry.note, !note.isEmpty {
							Text(note)
								.font(.system(size: 14))
								.foregroundColor(Color(hex: "#6C757D"))
								.lineLimit(2)
						}
					}
					
					Spacer()
					
					Circle()
						.fill(colorForMood(entry.score))
						.frame(width: 12, height: 12)
				}
				.padding(.vertical, 4)
			}
			.navigationTitle("Historial de Ánimo")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Cerrar") { dismiss() }
				}
			}
		}
	}
	
	private func colorForMood(_ mood: Int) -> Color {
		switch mood {
		case 1: return Color(hex: "#DC3545")
		case 2: return Color(hex: "#FD7E14")
		case 3: return Color(hex: "#FFC107")
		case 4: return Color(hex: "#20C997")
		case 5: return Color(hex: "#28A745")
		default: return Color(hex: "#6C757D")
		}
	}
}
