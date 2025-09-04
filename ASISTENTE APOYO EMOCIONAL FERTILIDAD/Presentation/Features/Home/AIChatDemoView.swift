import SwiftUI
import SwiftData

struct AIChatDemoView: View {
    @StateObject private var aiLuna = {
        // Crear un contexto en memoria para el demo
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ConversationEntity.self, MessageEntity.self, configurations: config)
        let context = ModelContext(container)
        return AILunaDemo(context: context)
    }()
    @State private var messageText = ""
    @State private var showingPersonalityDetails = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con información de Luna - más compacto
                PersonalityHeaderView(aiLuna: aiLuna)
                    .padding(.horizontal)
                    .padding(.vertical, 6) // Aún más compacto
                    .background(Color.blue.opacity(0.1))
                
                // Disclaimer ultra compacto
                DisclaimerBannerView()
                
                // Chat Messages - ocupa el espacio máximo disponible
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
                
                // Input Area - compacto
                MessageInputView(
                    messageText: $messageText,
                    onSend: {
                        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            aiLuna.sendMessage(messageText)
                            messageText = ""
                        }
                    }
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 6) // Muy compacto
                .background(Color(.systemGray6))
            }
            .navigationTitle("Luna AI Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Personalidad") {
                        showingPersonalityDetails = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingPersonalityDetails) {
                PersonalityDetailSheet(aiLuna: aiLuna)
            }
        }
    }
}

struct PersonalityHeaderView: View {
    @ObservedObject var aiLuna: AILunaDemo
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar más pequeño
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple, .blue, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40) // Más pequeño
                .overlay(
                    Text("🌙")
                        .font(.title3) // Más pequeño
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Luna AI")
                    .font(.headline) // Más pequeño que title2
                    .fontWeight(.bold)
                
                Text("Adaptación: \(Int(aiLuna.adaptationLevel * 100))%")
                    .font(.caption2) // Más pequeño
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Estado emocional más compacto
            VStack(alignment: .trailing, spacing: 2) {
                Text(aiLuna.currentEmotionalState.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(emotionalStateColor(aiLuna.currentEmotionalState))
            }
        }
    }
    
    private func emotionalStateColor(_ state: EmotionalState) -> Color {
        switch state {
        case .neutral: return .gray
        case .anxious: return .orange
        case .hopeful: return .green
        case .sad: return .blue
        case .excited: return .purple
        case .frustrated: return .red
        case .grateful: return .pink
        }
    }
}

struct PersonalityIndicator: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 3)
                    .frame(width: 30, height: 30)
                
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(value * 100))")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: AIMessage
    @State private var showingDetails = false
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Text(message.timestamp, format: .dateTime.hour().minute())
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 8) {
                        Text("🌙")
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(message.content)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                
                                // Botón de información para mostrar detalles
                                if message.detectedEmotion != nil {
                                    Button(action: { showingDetails = true }) {
                                        Image(systemName: "info.circle")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                            if let emotion = message.detectedEmotion {
                                HStack {
                                    Text("Emoción detectada: \(emotion.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .italic()
                                    
                                    if message.confidence > 0 {
                                        Text("(\(Int(message.confidence * 100))%)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text(message.timestamp, format: .dateTime.hour().minute())
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .sheet(isPresented: $showingDetails) {
                    MessageAnalysisSheet(message: message)
                }
                
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
                .lineLimit(1...4)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

struct PersonalityDetailSheet: View {
    @ObservedObject var aiLuna: AILunaDemo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .blue, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("🌙")
                                    .font(.largeTitle)
                            )
                        
                        Text("Luna AI Personality Engine")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Nivel de Adaptación: \(Int(aiLuna.adaptationLevel * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    // Personality Traits
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Rasgos de Personalidad")
                            .font(.headline)
                        
                        PersonalityTraitRow(
                            icon: "heart.fill",
                            label: "Empatía",
                            value: aiLuna.personalityTraits.empathy,
                            description: "Capacidad de comprender y compartir los sentimientos",
                            color: .pink
                        )
                        
                        PersonalityTraitRow(
                            icon: "hands.sparkles.fill",
                            label: "Apoyo",
                            value: aiLuna.personalityTraits.supportiveness,
                            description: "Nivel de soporte emocional proporcionado",
                            color: .blue
                        )
                        
                        PersonalityTraitRow(
                            icon: "brain.head.profile",
                            label: "Intuición",
                            value: aiLuna.personalityTraits.intuition,
                            description: "Capacidad de percibir emociones sutiles",
                            color: .purple
                        )
                        
                        PersonalityTraitRow(
                            icon: "sun.max.fill",
                            label: "Esperanza",
                            value: aiLuna.personalityTraits.hopefulness,
                            description: "Tendencia a mantener una perspectiva positiva",
                            color: .green
                        )
                    }
                    .padding()
                    
                    // Emotional State
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Estado Emocional Actual")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(aiLuna.currentEmotionalState.rawValue.capitalized)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("Detectado basado en el contexto de la conversación")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding()
                    
                    // Conversation Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Estadísticas de Conversación")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            StatItem(
                                icon: "message.fill",
                                label: "Mensajes",
                                value: "\(aiLuna.conversationHistory.count)"
                            )
                            
                            StatItem(
                                icon: "chart.line.uptrend.xyaxis",
                                label: "Adaptación",
                                value: "\(Int(aiLuna.adaptationLevel * 100))%"
                            )
                            
                            StatItem(
                                icon: "heart.text.square.fill",
                                label: "Contexto",
                                value: "\(aiLuna.conversationHistory.filter { !$0.isFromUser }.count)"
                            )
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Detalles de Luna")
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
}

struct PersonalityTraitRow: View {
    let icon: String
    let label: String
    let value: Double
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(value * 100))%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                ProgressView(value: value)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                    .frame(width: 60)
            }
        }
        .padding(.vertical, 8)
    }
}

struct StatItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Message Analysis Detail Sheet

struct MessageAnalysisSheet: View {
    let message: AIMessage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Análisis de Mensaje")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Luna AI - Explicabilidad")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Mensaje original
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mensaje Analizado")
                        .font(.headline)
                    
                    Text(message.content)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Análisis emocional
                if let emotion = message.detectedEmotion {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Análisis Emocional")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Emoción: \(emotion.rawValue.capitalized)")
                                    .fontWeight(.semibold)
                                
                                if message.confidence > 0 {
                                    Text("Confianza: \(Int(message.confidence * 100))%")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            // Indicador visual de confianza
                            if message.confidence > 0 {
                                CircularProgressView(progress: message.confidence, color: confidenceColor(message.confidence))
                            }
                        }
                        
                        if let rationale = message.rationale {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Explicación:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(rationale)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Detalles")
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
    
    private func confidenceColor(_ confidence: Double) -> Color {
        if confidence > 0.7 {
            return .green
        } else if confidence > 0.4 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Circular Progress View

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 4)
                .frame(width: 40, height: 40)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Disclaimer Banner Component

struct DisclaimerBannerView: View {
    var body: some View {
        // Banner ultra compacto - solo una línea muy delgada
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.orange)
                .font(.caption2)
            
            Text("Apoyo informativo - No reemplaza atención médica")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 3) // Muy poco padding vertical
        .background(Color.orange.opacity(0.05))
    }
}

#Preview {
    AIChatDemoView()
}
