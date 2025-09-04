import SwiftUI

/// Vista de demostración para mostrar el nuevo design system de Gynevia
/// Esta vista permite previsualizar todos los componentes profesionales
struct DesignSystemDemo: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Colors Demo
            ColorsDemo()
                .tabItem {
                    Image(systemName: "paintpalette.fill")
                    Text("Colores")
                }
                .tag(0)
            
            // Typography Demo
            TypographyDemo()
                .tabItem {
                    Image(systemName: "textformat")
                    Text("Tipografía")
                }
                .tag(1)
            
            // Components Demo
            ComponentsDemo()
                .tabItem {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("Componentes")
                }
                .tag(2)
            
            // Cards Demo
            CardsDemo()
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Tarjetas")
                }
                .tag(3)
        }
    }
}

// MARK: - Colors Demo
struct ColorsDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Sistema de Colores")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#212529"))
                
                // Primary Colors
                ColorSection(title: "Colores Primarios") {
                    ColorSwatch(name: "Primary", color: Color(hex: "#6B73FF"))
                    ColorSwatch(name: "Primary Light", color: Color(hex: "#9BA3FF"))
                    ColorSwatch(name: "Primary Dark", color: Color(hex: "#5A61D6"))
                }
                
                // Secondary Colors
                ColorSection(title: "Colores Secundarios") {
                    ColorSwatch(name: "Secondary", color: Color(hex: "#FF8A95"))
                    ColorSwatch(name: "Secondary Light", color: Color(hex: "#FFADB6"))
                    ColorSwatch(name: "Secondary Dark", color: Color(hex: "#E6707D"))
                }
                
                // Accent Colors
                ColorSection(title: "Colores de Acento") {
                    ColorSwatch(name: "Accent", color: Color(hex: "#4ECDC4"))
                    ColorSwatch(name: "Success", color: Color(hex: "#28A745"))
                    ColorSwatch(name: "Warning", color: Color(hex: "#FFC107"))
                    ColorSwatch(name: "Error", color: Color(hex: "#DC3545"))
                }
            }
            .padding(16)
        }
        .background(Color(hex: "#F8F9FA"))
    }
}

struct ColorSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                content
            }
        }
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#6C757D"))
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Typography Demo
struct TypographyDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Sistema de Tipografía")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#212529"))
                
                // Display Fonts
                TypographySection(title: "Display - Títulos Principales") {
                    Text("Display Large")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("Display Medium")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("Display Small")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
                
                // Headlines
                TypographySection(title: "Headlines - Títulos de Sección") {
                    Text("Headline Large")
                        .font(.system(size: 22, weight: .semibold))
                    Text("Headline Medium")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Headline Small")
                        .font(.system(size: 18, weight: .medium))
                }
                
                // Body Text
                TypographySection(title: "Body - Texto Principal") {
                    Text("Body Large - Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .font(.system(size: 16, weight: .regular))
                    Text("Body Medium - Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .font(.system(size: 14, weight: .regular))
                    Text("Body Small - Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .font(.system(size: 12, weight: .regular))
                }
                
                // Labels
                TypographySection(title: "Labels - Etiquetas y Botones") {
                    Text("Label Large")
                        .font(.system(size: 14, weight: .medium))
                    Text("Label Medium")
                        .font(.system(size: 12, weight: .medium))
                    Text("Label Small")
                        .font(.system(size: 10, weight: .medium))
                }
            }
            .padding(16)
        }
        .background(Color(hex: "#F8F9FA"))
    }
}

struct TypographySection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "#6B73FF"))
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Components Demo
struct ComponentsDemo: View {
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Componentes UI")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#212529"))
                
                // Buttons Section
                ComponentSection(title: "Botones") {
                    VStack(spacing: 12) {
                        // Primary Button
                        Button("Botón Primario") {}
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(hex: "#6B73FF"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Secondary Button
                        Button("Botón Secundario") {}
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(hex: "#FF8A95"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Outline Button
                        Button("Botón Outline") {}
                            .foregroundColor(Color(hex: "#6B73FF"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#6B73FF"), lineWidth: 1)
                            )
                    }
                }
                
                // Input Fields
                ComponentSection(title: "Campos de Entrada") {
                    VStack(spacing: 12) {
                        HStack {
                            TextField("Placeholder text", text: .constant(""))
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color(hex: "#F8F9FA"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#E9ECEF"), lineWidth: 1)
                        )
                        
                        HStack {
                            TextField("Campo activo", text: .constant("Texto de ejemplo"))
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#6B73FF"), lineWidth: 2)
                        )
                    }
                }
                
                // Progress Indicators
                ComponentSection(title: "Indicadores de Progreso") {
                    VStack(spacing: 16) {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Cargando...")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#6C757D"))
                        }
                        
                        ProgressView(value: 0.7)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#6B73FF")))
                    }
                }
            }
            .padding(16)
        }
        .background(Color(hex: "#F8F9FA"))
    }
}

struct ComponentSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            content
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Cards Demo
struct CardsDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Sistemas de Tarjetas")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#212529"))
                
                // Feature Cards
                CardSection(title: "Tarjetas de Características") {
                    VStack(spacing: 12) {
                        FeatureCardDemo(
                            title: "Asistente de Apoyo",
                            subtitle: "Conversa con tu asistente personalizado",
                            icon: "message.fill",
                            color: Color(hex: "#6B73FF")
                        )
                        
                        FeatureCardDemo(
                            title: "Registro de Ánimo",
                            subtitle: "Lleva un seguimiento de tu bienestar",
                            icon: "heart.fill",
                            color: Color(hex: "#FF8A95")
                        )
                    }
                }
                
                // Metric Cards
                CardSection(title: "Tarjetas de Métricas") {
                    HStack(spacing: 12) {
                        MetricCardDemo(
                            title: "Puntaje de Ánimo",
                            value: "8.2",
                            trend: "+15%",
                            trendColor: Color(hex: "#28A745")
                        )
                        
                        MetricCardDemo(
                            title: "Sesiones",
                            value: "24",
                            trend: "Esta semana",
                            trendColor: Color(hex: "#6C757D")
                        )
                    }
                }
                
                // Content Cards
                CardSection(title: "Tarjetas de Contenido") {
                    VStack(spacing: 12) {
                        ContentCardDemo(
                            title: "Consejo del Día",
                            content: "La respiración profunda puede ayudarte a reducir el estrés y la ansiedad en solo unos minutos.",
                            icon: "lightbulb.fill",
                            iconColor: Color(hex: "#FFC107")
                        )
                        
                        ContentCardDemo(
                            title: "Ejercicio Recomendado",
                            content: "Técnica 4-7-8: Inhala durante 4 segundos, mantén por 7, exhala por 8.",
                            icon: "leaf.fill",
                            iconColor: Color(hex: "#4ECDC4")
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(Color(hex: "#F8F9FA"))
    }
}

struct CardSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#212529"))
            
            content
        }
    }
}

// Demo Card Components
struct FeatureCardDemo: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#212529"))
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#6C757D"))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#ADB5BD"))
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct MetricCardDemo: View {
    let title: String
    let value: String
    let trend: String
    let trendColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#6C757D"))
                .textCase(.uppercase)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#212529"))
            
            Text(trend)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(trendColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ContentCardDemo: View {
    let title: String
    let content: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#212529"))
                
                Text(content)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#6C757D"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Supporting Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
#Preview {
    DesignSystemDemo()
}
