import SwiftUI

/// Tarjeta base profesional de Gynevia
/// Componente fundamental para mostrar contenido agrupado
public struct GyneviaCard<Content: View>: View {
    
    public enum CardStyle {
        case elevated
        case outlined
        case filled
    }
    
    public enum CardSize {
        case small
        case medium
        case large
    }
    
    private let content: Content
    private let style: CardStyle
    private let size: CardSize
    private let onTap: (() -> Void)?
    
    public init(
        style: CardStyle = .elevated,
        size: CardSize = .medium,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.size = size
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            content
                .padding(cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(
                    color: shadowColor,
                    radius: shadowRadius,
                    x: 0,
                    y: shadowOffset
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
    
    // MARK: - Computed Properties
    
    private var cardPadding: CGFloat {
        switch size {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .elevated, .outlined:
            return Color.white
        case .filled:
            return Color(hex: "#F8F9FA")
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outlined:
            return Color(hex: "#E9ECEF")
        default:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outlined:
            return 1
        default:
            return 0
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return Color.black.opacity(0.1)
        default:
            return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return 8
        default:
            return 0
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .elevated:
            return 2
        default:
            return 0
        }
    }
}

// MARK: - Specialized Card Components

/// Tarjeta para mostrar características o botones principales
public struct FeatureCard: View {
    private let title: String
    private let subtitle: String?
    private let icon: String
    private let action: () -> Void
    
    public init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        GyneviaCard(style: .elevated, onTap: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(hex: "#6B73FF"))
                    .frame(width: 48, height: 48)
                    .background(Color(hex: "#6B73FF").opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#212529"))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6C757D"))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#ADB5BD"))
            }
        }
    }
}

/// Tarjeta para métricas o estadísticas
public struct MetricCard: View {
    private let title: String
    private let value: String
    private let trend: String?
    private let trendDirection: TrendDirection
    
    public enum TrendDirection {
        case up, down, neutral
        
        var color: Color {
            switch self {
            case .up: return Color(hex: "#28A745")
            case .down: return Color(hex: "#DC3545")
            case .neutral: return Color(hex: "#6C757D")
            }
        }
        
        var icon: String {
            switch self {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            case .neutral: return "minus"
            }
        }
    }
    
    public init(
        title: String,
        value: String,
        trend: String? = nil,
        trendDirection: TrendDirection = .neutral
    ) {
        self.title = title
        self.value = value
        self.trend = trend
        self.trendDirection = trendDirection
    }
    
    public var body: some View {
        GyneviaCard(style: .elevated, size: .small) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#6C757D"))
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#212529"))
                
                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trendDirection.icon)
                            .font(.system(size: 10, weight: .medium))
                        
                        Text(trend)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(trendDirection.color)
                }
            }
        }
    }
}

// MARK: - Extension for Hex Color Support
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
    VStack(spacing: 16) {
        FeatureCard(
            title: "Chat with Assistant",
            subtitle: "Get emotional support",
            icon: "message.fill"
        ) {
            print("Chat tapped")
        }
        
        HStack(spacing: 16) {
            MetricCard(
                title: "Mood Score",
                value: "7.2",
                trend: "+12%",
                trendDirection: .up
            )
            
            MetricCard(
                title: "Sessions",
                value: "24",
                trend: "This week",
                trendDirection: .neutral
            )
        }
        
        GyneviaCard(style: .outlined) {
            Text("Custom card content")
                .padding()
        }
    }
    .padding()
}
