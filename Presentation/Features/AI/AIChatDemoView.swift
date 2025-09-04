import SwiftUI

struct AIChatDemoView: View {
    @StateObject private var aiLuna = AILunaDemo()
    @State private var messageText = ""
    @State private var showingPersonalityDetails = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con información de Luna
                PersonalityHeaderView(aiLuna: aiLuna)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(aiLuna.conversationHistory) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: aiLuna.conversationHistory.count) { _ in
                        if let lastMessage = aiLuna.conversationHistory.last {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                MessageInputView(
                    messageText: $messageText,
                    onSend: {
                        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            aiLuna.sendMessage(messageText)
                            messageText = ""
                        }
                    }
                )
                .padding()
                .background(Color(.systemGray6))
            }
            .navigationTitle("Luna AI Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Personalidad") {
                        showingPersonalityDetails = true
                    }
                }
            }
            .sheet(isPresented: $showingPersonalityDetails) {
                PersonalityDetailSheet(aiLuna: aiLuna)
            }
        }
    }
}

// MARK: - Header Components

struct PersonalityHeaderView: View {
    @ObservedObject var aiLuna: AILunaDemo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("🌙 Luna")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(aiLuna.currentMood.emoji)
                        .font(.title2)
                }
                
                Text("Tu compañera empática de fertilidad")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Relación: \(aiLuna.relationship.description)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                PersonalityIndicator(
                    label: "Tono",
                    value: aiLuna.aiPersonality.tone.description
                )
                
                PersonalityIndicator(
                    label: "Energía",
                    value: aiLuna.aiPersonality.energy.description
                )
                
                PersonalityIndicator(
                    label: "Enfoque",
                    value: aiLuna.aiPersonality.approach.description
                )
            }
        }
    }
}

struct PersonalityIndicator: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.2))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Message Components

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
            }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.sender == .user 
                            ? Color.blue 
                            : Color(.systemGray5)
                    )
                    .foregroundColor(
                        message.sender == .user 
                            ? .white 
                            : .primary
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                
                HStack(spacing: 4) {
                    Text(message.mood.emoji)
                        .font(.caption2)
                    
                    Text(DateFormatter.timeFormatter.string(from: message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if message.sender == .user {
                        Spacer()
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity * 0.75, alignment: message.sender == .user ? .trailing : .leading)
            
            if message.sender == .ai {
                Spacer()
            }
        }
    }
}

struct MessageInputView: View {
    @Binding var messageText: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Escribe tu mensaje...", text: $messageText, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(1...4)
                .onSubmit {
                    onSend()
                }
            
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                            ? Color.gray 
                            : Color.blue
                    )
                    .clipShape(Circle())
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

// MARK: - Detail Sheet

struct PersonalityDetailSheet: View {
    @ObservedObject var aiLuna: AILunaDemo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🌙")
                            .font(.system(size: 60))
                        
                        Text("Luna - AI Empática")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Tu compañera de apoyo emocional para el journey de fertilidad")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    // Estado Actual
                    GroupBox("Estado Emocional Detectado") {
                        HStack {
                            Text(aiLuna.currentMood.emoji)
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text(moodDescription(aiLuna.currentMood))
                                    .fontWeight(.medium)
                                
                                Text("Luna adapta su personalidad según tu estado emocional")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Personalidad Actual
                    GroupBox("Personalidad Adaptativa Actual") {
                        VStack(spacing: 12) {
                            PersonalityDetailRow(
                                icon: "💬",
                                title: "Tono de Comunicación",
                                value: aiLuna.aiPersonality.tone.description
                            )
                            
                            PersonalityDetailRow(
                                icon: "⚡",
                                title: "Nivel de Energía",
                                value: aiLuna.aiPersonality.energy.description
                            )
                            
                            PersonalityDetailRow(
                                icon: "🎯",
                                title: "Enfoque Conversacional",
                                value: aiLuna.aiPersonality.approach.description
                            )
                        }
                    }
                    
                    // Relación
                    GroupBox("Evolución de la Relación") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Nivel Actual:")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(aiLuna.relationship.description)
                                    .foregroundColor(.blue)
                            }
                            
                            Text("Mensajes intercambiados: \(aiLuna.conversationHistory.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ProgressView(value: relationshipProgress(aiLuna.relationship), total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        }
                    }
                    
                    // Ejemplos de Frases
                    GroupBox("Ejemplos de Respuestas por Estado de Ánimo") {
                        VStack(spacing: 12) {
                            ExampleResponseRow(
                                mood: "😰 Ansiosa",
                                example: "\"Entiendo que te sientes ansiosa. Es completamente normal durante este journey...\""
                            )
                            
                            ExampleResponseRow(
                                mood: "😢 Triste",
                                example: "\"Mi corazón está contigo en este momento. Estos días grises son duros...\""
                            )
                            
                            ExampleResponseRow(
                                mood: "🌟 Esperanzada",
                                example: "\"¡Qué hermoso escuchar esperanza en tus palabras! Esa energía es valiosa...\""
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("Personalidad de Luna")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func moodDescription(_ mood: UserMood) -> String {
        switch mood {
        case .anxious: return "Ansiosa"
        case .sad: return "Triste"
        case .hopeful: return "Esperanzada"
        case .frustrated: return "Frustrada"
        case .neutral: return "Neutral"
        case .supportive: return "Apoyada"
        }
    }
    
    private func relationshipProgress(_ relationship: RelationshipLevel) -> Double {
        switch relationship {
        case .newUser: return 0.33
        case .developing: return 0.66
        case .established: return 1.0
        }
    }
}

struct PersonalityDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

struct ExampleResponseRow: View {
    let mood: String
    let example: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(mood)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            
            Text(example)
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    AIChatDemoView()
}
