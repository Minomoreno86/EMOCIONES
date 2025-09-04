import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var hasConsented = false
    @State private var showMedicalDisclaimer = false
    @State private var showEmergencySheet = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "#6B73FF"), Color(hex: "#9BA3FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                WelcomePage()
                    .tag(0)
                
                ConsentPage(hasConsented: $hasConsented)
                    .tag(1)
                
                MedicalDisclaimerPage(showEmergency: $showEmergencySheet)
                    .tag(2)
                
                CompletionPage(onComplete: {
                    hasCompletedOnboarding = true
                })
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .sheet(isPresented: $showEmergencySheet) {
                EmergencySheet()
            }
        }
    }
}

// MARK: - Welcome Page
struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // App Icon/Logo
            VStack(spacing: 16) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 120, height: 120)
                    )
                
                Text("onboarding_welcome_title")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("onboarding_welcome_subtitle")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Feature Highlights
            VStack(spacing: 16) {
                FeatureHighlight(
                    icon: "message.circle.fill",
                    title: "Apoyo Personalizado",
                    description: "Conversaciones empáticas disponibles 24/7"
                )
                
                FeatureHighlight(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Seguimiento de Bienestar",
                    description: "Registra y analiza tu estado emocional"
                )
                
                FeatureHighlight(
                    icon: "leaf.circle.fill",
                    title: "Mindfulness",
                    description: "Técnicas de relajación y meditación"
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Consent Page
struct ConsentPage: View {
    @Binding var hasConsented: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("onboarding_consent_title")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 16) {
                    Text("onboarding_consent_description")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    // Privacy Features
                    VStack(spacing: 12) {
                        PrivacyFeature(
                            icon: "iphone",
                            text: "Datos almacenados localmente"
                        )
                        
                        PrivacyFeature(
                            icon: "wifi.slash",
                            text: "Sin seguimiento o análisis externos"
                        )
                        
                        PrivacyFeature(
                            icon: "eye.slash.fill",
                            text: "Información completamente privada"
                        )
                    }
                    .padding(.top, 16)
                }
            }
            
            Spacer()
            
            // Consent Toggle
            ProfessionalToggle(
                text: "onboarding_consent_toggle",
                isOn: $hasConsented
            )
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Medical Disclaimer Page
struct MedicalDisclaimerPage: View {
    @Binding var showEmergency: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "cross.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("onboarding_medical_title")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 16) {
                    Text("onboarding_medical_disclaimer")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    // Important Notes
                    VStack(spacing: 12) {
                        DisclaimerNote(
                            icon: "info.circle.fill",
                            text: "No sustituye atención médica profesional"
                        )
                        
                        DisclaimerNote(
                            icon: "phone.circle.fill",
                            text: "En emergencias, contacta servicios médicos"
                        )
                        
                        DisclaimerNote(
                            icon: "heart.circle.fill",
                            text: "Complementa tu tratamiento actual"
                        )
                    }
                    .padding(.top, 16)
                }
            }
            
            Spacer()
            
            // Emergency Button
            Button(action: { showEmergency = true }) {
                HStack {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 16))
                    
                    Text("onboarding_emergency_button")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(Color(hex: "#6B73FF"))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Completion Page
struct CompletionPage: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("¡Todo Listo!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Tu espacio de bienestar emocional está preparado")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Comienza cuando te sientas lista")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Button(action: onComplete) {
                    HStack {
                        Text("Comenzar")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(Color(hex: "#6B73FF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Supporting Components

struct FeatureHighlight: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
    }
}

struct PrivacyFeature: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

struct DisclaimerNote: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

struct ProfessionalToggle: View {
    let text: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }) {
            HStack {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isOn ? .white : .white.opacity(0.6))
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(16)
            .background(Color.white.opacity(isOn ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Emergency Sheet (Reusing from original)
struct EmergencySheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("emergency_title")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#212529"))
                
                VStack(alignment: .leading, spacing: 16) {
                    EmergencyContactRow(
                        icon: "phone.fill",
                        title: "emergency_phone_911",
                        color: Color(hex: "#DC3545")
                    )
                    
                    EmergencyContactRow(
                        icon: "phone.fill",
                        title: "emergency_phone_local",
                        color: Color(hex: "#6B73FF")
                    )
                    
                    EmergencyContactRow(
                        icon: "heart.fill",
                        title: "emergency_phone_mental_health",
                        color: Color(hex: "#20C997")
                    )
                }
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("emergency_nav_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("emergency_close") { dismiss() }
                }
            }
        }
    }
}

struct EmergencyContactRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "#212529"))
            
            Spacer()
        }
        .padding(16)
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
