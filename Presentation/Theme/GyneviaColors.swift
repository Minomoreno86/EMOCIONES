import SwiftUI

/// Sistema de colores profesional para Gynevia
/// Diseñado específicamente para aplicaciones de salud mental y bienestar
public struct GyneviaColors {
    
    // MARK: - Primary Colors
    static let primary = Color(hex: "#6B73FF") // Lavanda profesional, calmante
    static let primaryLight = Color(hex: "#9BA3FF")
    static let primaryDark = Color(hex: "#5A61D6")
    
    // MARK: - Secondary Colors
    static let secondary = Color(hex: "#FF8A95") // Rosa suave, empático
    static let secondaryLight = Color(hex: "#FFADB6")
    static let secondaryDark = Color(hex: "#E6707D")
    
    // MARK: - Accent Colors
    static let accent = Color(hex: "#4ECDC4") // Verde agua, esperanza
    static let accentLight = Color(hex: "#7ED7D1")
    static let accentDark = Color(hex: "#3BB5AD")
    
    // MARK: - Neutral Colors
    static let neutralWhite = Color(hex: "#FFFFFF")
    static let neutralLight = Color(hex: "#F8F9FA")
    static let neutralMedium = Color(hex: "#E9ECEF")
    static let neutralDark = Color(hex: "#6C757D")
    static let neutralBlack = Color(hex: "#212529")
    
    // MARK: - Semantic Colors
    static let success = Color(hex: "#28A745")
    static let warning = Color(hex: "#FFC107")
    static let error = Color(hex: "#DC3545")
    static let info = Color(hex: "#17A2B8")
    
    // MARK: - Background Colors
    static let backgroundPrimary = Color(hex: "#FFFFFF")
    static let backgroundSecondary = Color(hex: "#F8F9FA")
    static let backgroundTertiary = Color(hex: "#E9ECEF")
    
    // MARK: - Text Colors
    static let textPrimary = Color(hex: "#212529")
    static let textSecondary = Color(hex: "#6C757D")
    static let textTertiary = Color(hex: "#ADB5BD")
    static let textOnPrimary = Color.white
    
    // MARK: - Shadow Colors
    static let shadowLight = Color.black.opacity(0.05)
    static let shadowMedium = Color.black.opacity(0.1)
    static let shadowDark = Color.black.opacity(0.25)
    
    // MARK: - Gradient Colors
    static let gradientPrimary = LinearGradient(
        colors: [primary, primaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSecondary = LinearGradient(
        colors: [secondary, secondaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientAccent = LinearGradient(
        colors: [accent, accentLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientBackground = LinearGradient(
        colors: [backgroundPrimary, backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Color Extension for Hex Support
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
