import SwiftUI

/// Botón principal estilizado de Gynevia
/// Soporte para diferentes tamaños, estados y tipos
public struct GyneviaButton: View {
    
    public enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
    }
    
    public enum ButtonSize {
        case small
        case medium
        case large
    }
    
    private let title: String
    private let action: () -> Void
    private let style: ButtonStyle
    private let size: ButtonSize
    private let isLoading: Bool
    private let isDisabled: Bool
    private let icon: String?
    
    public init(
        _ title: String,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.icon = icon
    }
    
    public var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                action()
            }
        }) {
            HStack(spacing: GyneviaSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: iconSize, weight: .medium))
                }
                
                Text(title)
                    .font(buttonFont)
                    .fontWeight(.semibold)
            }
            .foregroundColor(textColor)
            .frame(height: buttonHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, horizontalPadding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .disabled(isLoading || isDisabled)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    @State private var isPressed = false
    
    // MARK: - Computed Properties
    
    private var buttonHeight: CGFloat {
        switch size {
        case .small: return GyneviaSpacing.buttonHeightSmall
        case .medium: return GyneviaSpacing.buttonHeightMedium
        case .large: return GyneviaSpacing.buttonHeightLarge
        }
    }
    
    private var buttonFont: Font {
        switch size {
        case .small: return GyneviaTypography.labelMedium
        case .medium: return GyneviaTypography.labelLarge
        case .large: return GyneviaTypography.buttonText
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return GyneviaSpacing.md
        case .medium: return GyneviaSpacing.lg
        case .large: return GyneviaSpacing.xl
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return GyneviaSpacing.radiusSM
        case .medium: return GyneviaSpacing.radiusMD
        case .large: return GyneviaSpacing.radiusLG
        }
    }
    
    private var iconSize: CGFloat {
        switch size {
        case .small: return GyneviaSpacing.iconSmall
        case .medium: return GyneviaSpacing.iconMedium
        case .large: return GyneviaSpacing.iconLarge
        }
    }
    
    private var backgroundColor: Color {
        let isInactive = isLoading || isDisabled
        
        switch style {
        case .primary:
            return isInactive ? GyneviaColors.neutralMedium : GyneviaColors.primary
        case .secondary:
            return isInactive ? GyneviaColors.neutralMedium : GyneviaColors.secondary
        case .outline, .ghost:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        let isInactive = isLoading || isDisabled
        
        if isInactive {
            return GyneviaColors.textTertiary
        }
        
        switch style {
        case .primary, .secondary:
            return GyneviaColors.textOnPrimary
        case .outline:
            return GyneviaColors.primary
        case .ghost:
            return GyneviaColors.textPrimary
        }
    }
    
    private var borderColor: Color {
        let isInactive = isLoading || isDisabled
        
        switch style {
        case .primary, .secondary:
            return Color.clear
        case .outline:
            return isInactive ? GyneviaColors.neutralMedium : GyneviaColors.primary
        case .ghost:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return GyneviaSpacing.borderMedium
        default:
            return 0
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        GyneviaButton("Primary Button", style: .primary) {
            print("Primary tapped")
        }
        
        GyneviaButton("Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }
        
        GyneviaButton("Outline Button", style: .outline) {
            print("Outline tapped")
        }
        
        GyneviaButton("Loading", style: .primary, isLoading: true) {
            print("Loading")
        }
        
        GyneviaButton("With Icon", style: .primary, icon: "heart.fill") {
            print("Icon button tapped")
        }
        
        GyneviaButton("Disabled", style: .primary, isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
}
