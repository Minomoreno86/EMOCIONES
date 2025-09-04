import SwiftUI

/// Sistema de espaciado y dimensiones para Gynevia
/// Proporciona consistencia en layouts y elementos UI
public struct GyneviaSpacing {
    
    // MARK: - Basic Spacing
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
    
    // MARK: - Component Spacing
    static let buttonPadding: EdgeInsets = EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
    static let cardPadding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    static let screenPadding: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let sectionPadding: EdgeInsets = EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0)
    
    // MARK: - Corner Radius
    static let radiusXS: CGFloat = 4
    static let radiusSM: CGFloat = 8
    static let radiusMD: CGFloat = 12
    static let radiusLG: CGFloat = 16
    static let radiusXL: CGFloat = 24
    static let radiusFull: CGFloat = 1000 // Para elementos circulares
    
    // MARK: - Border Width
    static let borderThin: CGFloat = 0.5
    static let borderMedium: CGFloat = 1
    static let borderThick: CGFloat = 2
    
    // MARK: - Shadow Properties
    static let shadowRadius: CGFloat = 8
    static let shadowOffset = CGSize(width: 0, height: 2)
    
    // MARK: - Component Heights
    static let buttonHeightSmall: CGFloat = 36
    static let buttonHeightMedium: CGFloat = 44
    static let buttonHeightLarge: CGFloat = 52
    
    static let textFieldHeight: CGFloat = 48
    static let cardMinHeight: CGFloat = 80
    static let navigationBarHeight: CGFloat = 44
    
    // MARK: - Icon Sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 32
    static let iconXLarge: CGFloat = 48
    
    // MARK: - Animation Durations
    static let animationFast: Double = 0.2
    static let animationMedium: Double = 0.3
    static let animationSlow: Double = 0.5
}

/// Sistema de sombras para Gynevia
public struct GynevoShadows {
    
    static let none = DropShadow(
        color: .clear,
        radius: 0,
        x: 0,
        y: 0
    )
    
    static let small = DropShadow(
        color: GyneviaColors.shadowLight,
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let medium = DropShadow(
        color: GyneviaColors.shadowMedium,
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let large = DropShadow(
        color: GyneviaColors.shadowMedium,
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let extraLarge = DropShadow(
        color: GyneviaColors.shadowDark,
        radius: 16,
        x: 0,
        y: 8
    )
}

public struct DropShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions for Consistent Styling
extension View {
    
    func gyneviaCardStyle() -> some View {
        self
            .background(GyneviaColors.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: GyneviaSpacing.radiusMD))
            .shadow(
                color: GyneviaColors.shadowMedium,
                radius: GyneviaSpacing.shadowRadius / 2,
                x: 0,
                y: GyneviaSpacing.shadowOffset.height
            )
    }
    
    func gyneviaScreenPadding() -> some View {
        self.padding(GyneviaSpacing.screenPadding)
    }
    
    func gyneviaSectionSpacing() -> some View {
        self.padding(GyneviaSpacing.sectionPadding)
    }
    
    func gyneviaAnimation() -> some View {
        self.animation(.easeInOut(duration: GyneviaSpacing.animationMedium), value: true)
    }
    
    func gyneviaFastAnimation() -> some View {
        self.animation(.easeInOut(duration: GyneviaSpacing.animationFast), value: true)
    }
}
