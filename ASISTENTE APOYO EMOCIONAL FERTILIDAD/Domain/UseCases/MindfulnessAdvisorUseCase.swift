import Foundation

public final class MindfulnessAdvisorUseCase: MindfulnessAdvisor {
    public init() {}
    
    public func suggest(from mood: MoodEntryEntity) -> String {
        switch mood.score {
        case 1...2:
            return mood.score == 1 ? 
                "Considera una sesión de respiración profunda de 10 minutos" :
                "Te sugiero un ejercicio de grounding de 5 minutos"
        case 3:
            return "Una breve meditación de 5 minutos puede ayudarte a mantener el equilibrio"
        case 4...5:
            return mood.score == 5 ?
                "¡Excelente! Mantén esta energía con una sesión de gratitud" :
                "Una sesión de visualización positiva puede potenciar tu bienestar"
        default:
            return "Considera una pausa consciente de 3 minutos"
        }
    }
}
