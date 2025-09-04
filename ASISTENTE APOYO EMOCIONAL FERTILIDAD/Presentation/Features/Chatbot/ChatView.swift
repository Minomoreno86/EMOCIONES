import SwiftUI
import SwiftData

struct ChatView: View {
	@Environment(\.modelContext) private var modelContext
	@StateObject private var orchestrator: ChatOrchestrator
	@State private var input: String = ""
	@AppStorage("app_locale") private var locale: String = "es"
	
	init() {
		// This will be properly initialized in onAppear
		self._orchestrator = StateObject(wrappedValue: ChatOrchestrator(modelContext: ModelContext(try! ModelContainer(for: ChatMessageEntity.self))))
	}
	
	var body: some View {
		VStack(spacing: 0) {
			// Messages List
			ScrollViewReader { proxy in
				ScrollView {
					LazyVStack(spacing: 16) {
						ForEach(orchestrator.messages) { message in
							MessageBubble(message: message)
								.id(message.id)
						}
					}
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
				}
				.onChange(of: orchestrator.messages.count) { _, _ in
					if let lastMessage = orchestrator.messages.last {
						withAnimation(.easeInOut(duration: 0.3)) {
							proxy.scrollTo(lastMessage.id, anchor: .bottom)
						}
					}
				}
			}
			
			// Typing Indicator
			if orchestrator.isLoading {
				TypingIndicator()
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
			}
			
			// Input Area
			VStack(spacing: 0) {
				Divider()
					.background(Color(hex: "#E9ECEF"))
				
				HStack(spacing: 12) {
					HStack(spacing: 8) {
						TextField("chat_input_placeholder", text: $input, axis: .vertical)
							.textFieldStyle(PlainTextFieldStyle())
							.font(.system(size: 16))
							.lineLimit(1...4)
							.padding(.horizontal, 16)
							.padding(.vertical, 12)
						
						if !input.isEmpty {
							Button(action: {
								Task {
									await sendMessage()
								}
							}) {
								Image(systemName: "arrow.up.circle.fill")
									.font(.system(size: 24))
									.foregroundColor(Color(hex: "#6B73FF"))
							}
							.disabled(orchestrator.isLoading)
							.padding(.trailing, 8)
						}
					}
					.background(Color(hex: "#F8F9FA"))
					.clipShape(RoundedRectangle(cornerRadius: 24))
					.overlay(
						RoundedRectangle(cornerRadius: 24)
							.stroke(Color(hex: "#E9ECEF"), lineWidth: 1)
					)
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 12)
				.background(Color.white)
			}
		}
		.background(Color(hex: "#F8F9FA"))
		.navigationTitle("chat_title")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			orchestrator.loadMessages()
		}
	}
	
	private func sendMessage() async {
		guard !input.isEmpty else { return }
		let messageText = input
		input = ""
		await orchestrator.sendMessage(messageText, locale: locale)
	}
}

// MARK: - Message Bubble Component
struct MessageBubble: View {
	let message: ChatMessageEntity
	
	var body: some View {
		HStack {
			if isUser {
				Spacer(minLength: 50)
				messageContent
			} else {
				messageContent
				Spacer(minLength: 50)
			}
		}
	}
	
	private var isUser: Bool {
		message.role == "user"
	}
	
	private var messageContent: some View {
		VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
			Text(message.content)
				.font(.system(size: 16))
				.foregroundColor(isUser ? .white : Color(hex: "#212529"))
				.padding(.horizontal, 16)
				.padding(.vertical, 12)
				.background(backgroundColor)
				.clipShape(MessageBubbleShape(isUser: isUser))
			
			Text(message.createdAt, style: .time)
				.font(.system(size: 11))
				.foregroundColor(Color(hex: "#ADB5BD"))
				.padding(.horizontal, 4)
		}
	}
	
	private var backgroundColor: Color {
		isUser ? Color(hex: "#6B73FF") : Color.white
	}
}

// MARK: - Custom Message Bubble Shape
struct MessageBubbleShape: Shape {
	let isUser: Bool
	
	func path(in rect: CGRect) -> Path {
		let radius: CGFloat = 16
		let tailSize: CGFloat = 8
		
		var path = Path()
		
		if isUser {
			// User bubble (right side with tail on bottom right)
			path.move(to: CGPoint(x: radius, y: 0))
			path.addLine(to: CGPoint(x: rect.width - radius, y: 0))
			path.addQuadCurve(to: CGPoint(x: rect.width, y: radius), control: CGPoint(x: rect.width, y: 0))
			path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius - tailSize))
			path.addLine(to: CGPoint(x: rect.width + tailSize, y: rect.height))
			path.addLine(to: CGPoint(x: rect.width - radius, y: rect.height))
			path.addQuadCurve(to: CGPoint(x: rect.width - radius - tailSize, y: rect.height - tailSize), control: CGPoint(x: rect.width - radius, y: rect.height))
			path.addLine(to: CGPoint(x: radius, y: rect.height))
			path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - radius), control: CGPoint(x: 0, y: rect.height))
			path.addLine(to: CGPoint(x: 0, y: radius))
			path.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x: 0, y: 0))
		} else {
			// Assistant bubble (left side with tail on bottom left)
			path.move(to: CGPoint(x: radius + tailSize, y: 0))
			path.addLine(to: CGPoint(x: rect.width - radius, y: 0))
			path.addQuadCurve(to: CGPoint(x: rect.width, y: radius), control: CGPoint(x: rect.width, y: 0))
			path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius))
			path.addQuadCurve(to: CGPoint(x: rect.width - radius, y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
			path.addLine(to: CGPoint(x: radius + tailSize, y: rect.height))
			path.addQuadCurve(to: CGPoint(x: tailSize, y: rect.height - radius), control: CGPoint(x: tailSize, y: rect.height))
			path.addLine(to: CGPoint(x: -tailSize, y: rect.height))
			path.addLine(to: CGPoint(x: 0, y: rect.height - radius - tailSize))
			path.addLine(to: CGPoint(x: 0, y: radius))
			path.addQuadCurve(to: CGPoint(x: radius + tailSize, y: 0), control: CGPoint(x: 0, y: 0))
		}
		
		return path
	}
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
	@State private var animationPhase = 0
	
	var body: some View {
		HStack {
			HStack(spacing: 4) {
				ForEach(0..<3) { index in
					Circle()
						.fill(Color(hex: "#ADB5BD"))
						.frame(width: 8, height: 8)
						.scaleEffect(animationPhase == index ? 1.2 : 0.8)
						.animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: animationPhase)
				}
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 16))
			
			Spacer(minLength: 50)
		}
		.onAppear {
			animationPhase = 0
		}
	}
}
