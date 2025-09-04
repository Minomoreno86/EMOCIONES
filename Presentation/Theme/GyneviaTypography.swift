import SwiftUI

/// Sistema de tipografía profesional para Gynevia
/// Optimizado para legibilidad y jerarquía visual en aplicaciones de salud
public struct GyneviaTypography {
    
    // MARK: - Display Fonts (Títulos principales)
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .rounded)
    
    // MARK: - Headline Fonts (Títulos de sección)
    static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .default)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .default)
    static let headlineSmall = Font.system(size: 18, weight: .medium, design: .default)
    
    // MARK: - Title Fonts (Títulos menores)
    static let titleLarge = Font.system(size: 16, weight: .medium, design: .default)
    static let titleMedium = Font.system(size: 14, weight: .medium, design: .default)
    static let titleSmall = Font.system(size: 12, weight: .medium, design: .default)
    
    // MARK: - Body Fonts (Texto principal)
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
    
    // MARK: - Label Fonts (Etiquetas y botones)
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 10, weight: .medium, design: .default)
    
    // MARK: - Caption Fonts (Texto auxiliar)
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 10, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 8, weight: .regular, design: .default)
    
    // MARK: - Custom Fonts for Special Cases
    static let chatMessage = Font.system(size: 15, weight: .regular, design: .default)
    static let moodScore = Font.system(size: 24, weight: .bold, design: .rounded)
    static let timeDisplay = Font.system(size: 18, weight: .medium, design: .monospaced)
    static let cardTitle = Font.system(size: 18, weight: .semibold, design: .default)
    static let cardSubtitle = Font.system(size: 14, weight: .regular, design: .default)
    static let buttonText = Font.system(size: 16, weight: .semibold, design: .default)
    static let navigationTitle = Font.system(size: 20, weight: .bold, design: .rounded)
}

// MARK: - Text Style Modifiers
extension Text {
    func gyneviaDisplayLarge() -> some View {
        self.font(GyneviaTypography.displayLarge)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaDisplayMedium() -> some View {
        self.font(GyneviaTypography.displayMedium)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaDisplaySmall() -> some View {
        self.font(GyneviaTypography.displaySmall)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaHeadlineLarge() -> some View {
        self.font(GyneviaTypography.headlineLarge)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaHeadlineMedium() -> some View {
        self.font(GyneviaTypography.headlineMedium)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaHeadlineSmall() -> some View {
        self.font(GyneviaTypography.headlineSmall)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaBodyLarge() -> some View {
        self.font(GyneviaTypography.bodyLarge)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaBodyMedium() -> some View {
        self.font(GyneviaTypography.bodyMedium)
            .foregroundColor(GyneviaColors.textSecondary)
    }
    
    func gyneviaBodySmall() -> some View {
        self.font(GyneviaTypography.bodySmall)
            .foregroundColor(GyneviaColors.textSecondary)
    }
    
    func gyneviaLabelLarge() -> some View {
        self.font(GyneviaTypography.labelLarge)
            .foregroundColor(GyneviaColors.textPrimary)
    }
    
    func gyneviaLabelMedium() -> some View {
        self.font(GyneviaTypography.labelMedium)
            .foregroundColor(GyneviaColors.textSecondary)
    }
    
    func gyneviaCaptionLarge() -> some View {
        self.font(GyneviaTypography.captionLarge)
            .foregroundColor(GyneviaColors.textTertiary)
    }
    
    func gyneviaCaptionMedium() -> some View {
        self.font(GyneviaTypography.captionMedium)
            .foregroundColor(GyneviaColors.textTertiary)
    }
}
