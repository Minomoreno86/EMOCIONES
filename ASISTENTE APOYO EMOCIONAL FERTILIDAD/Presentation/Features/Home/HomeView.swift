import SwiftUI

struct HomeView: View {
    let navigate: (String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header Section
                headerSection
                
                // Quick Actions
                quickActionsSection
                
                // Today's Summary
                todaySummarySection
                
                // Main Features
                mainFeaturesSection
                
                // Footer spacing
                Color.clear
                    .frame(height: 40)
            }
            .padding(.horizontal, 16)
        }
        .background(
            LinearGradient(
                colors: [Color.white, Color(hex: "#F8F9FA")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("home_title")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("¡Bienvenida!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#212529"))
                    
                    Text("Tu espacio de bienestar emocional")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#6C757D"))
                }
                
                Spacer()
                
                // Profile or settings quick access
                Button(action: { navigate("settings") }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#6B73FF"))
                        .frame(width: 44, height: 44)
                        .background(Color(hex: "#6B73FF").opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Acciones Rápidas")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "message.fill",
                    title: "Chat",
                    color: Color(hex: "#6B73FF")
                ) {
                    navigate("chat")
                }
                
                QuickActionButton(
                    icon: "heart.fill",
                    title: "Ánimo",
                    color: Color(hex: "#FF8A95")
                ) {
                    navigate("mood")
                }
                
                QuickActionButton(
                    icon: "leaf.fill",
                    title: "Mindfulness",
                    color: Color(hex: "#4ECDC4")
                ) {
                    navigate("mindfulness")
                }
                
                QuickActionButton(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Estadísticas",
                    color: Color(hex: "#FFC107")
                ) {
                    navigate("insights")
                }
            }
        }
    }
    
    // MARK: - Today's Summary
    private var todaySummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resumen de Hoy")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            HStack(spacing: 12) {
                SimpleMetricCard(
                    title: "Estado de Ánimo",
                    value: "8.2",
                    subtitle: "+15% esta semana",
                    color: Color(hex: "#FF8A95")
                )
                
                SimpleMetricCard(
                    title: "Sesiones",
                    value: "3",
                    subtitle: "Completadas hoy",
                    color: Color(hex: "#4ECDC4")
                )
            }
        }
    }
    
    // MARK: - Main Features
    private var mainFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Herramientas de Bienestar")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            VStack(spacing: 12) {
                // Nueva tarjeta para Luna AI Demo
                SimpleFeatureCard(
                    icon: "sparkles",
                    title: "🌙 Luna AI Demo",
                    subtitle: "Conoce a tu compañera empática de IA",
                    color: Color(hex: "#9BA3FF")
                ) {
                    navigate("luna_demo")
                }
                
                SimpleFeatureCard(
                    icon: "brain.head.profile",
                    title: "Asistente de Apoyo",
                    subtitle: "Conversa con tu asistente personalizado",
                    color: Color(hex: "#6B73FF")
                ) {
                    navigate("chat")
                }
                
                SimpleFeatureCard(
                    icon: "heart.text.square",
                    title: "Registro de Ánimo",
                    subtitle: "Lleva un seguimiento de tu bienestar emocional",
                    color: Color(hex: "#FF8A95")
                ) {
                    navigate("mood")
                }
                
                SimpleFeatureCard(
                    icon: "figure.mind.and.body",
                    title: "Ejercicios de Mindfulness",
                    subtitle: "Técnicas de relajación y meditación",
                    color: Color(hex: "#4ECDC4")
                ) {
                    navigate("mindfulness")
                }
                
                SimpleFeatureCard(
                    icon: "chart.bar.doc.horizontal",
                    title: "Tendencias y Patrones",
                    subtitle: "Analiza tu progreso y patrones emocionales",
                    color: Color(hex: "#FFC107")
                ) {
                    navigate("insights")
                }
            }
        }
    }
}

// MARK: - Quick Action Button Component
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#6C757D"))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Simple Metric Card Component
struct SimpleMetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#6C757D"))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#6C757D"))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Simple Feature Card Component
struct SimpleFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#212529"))
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#6C757D"))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#6C757D"))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
