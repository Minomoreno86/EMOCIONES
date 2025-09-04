import XCTest
@testable import ASISTENTE_APOYO_EMOCIONAL_FERTILIDAD

final class EmotionAnalysisTests: XCTestCase {
    
    var analyzer: RegexEmotionAnalyzer!
    
    override func setUp() {
        super.setUp()
        analyzer = RegexEmotionAnalyzer()
    }
    
    override func tearDown() {
        analyzer = nil
        super.tearDown()
    }
    
    // MARK: - Negation Tests
    
    func testEmotionNegation() {
        // Test negation handling
        let result1 = analyzer.detect(in: "No estoy triste, solo cansado")
        XCTAssertNotEqual(result1.state, .sad, "Should not detect sadness when negated")
        
        let result2 = analyzer.detect(in: "Estoy muy triste y deprimida")
        XCTAssertEqual(result2.state, .sad, "Should detect sadness when not negated")
        XCTAssertGreaterThan(result2.confidence, 0.5, "Confidence should be high for clear emotional expression")
    }
    
    func testMultipleNegations() {
        let result = analyzer.detect(in: "No estoy para nada ansiosa, nunca me preocupo")
        XCTAssertNotEqual(result.state, .anxious, "Should not detect anxiety when multiple negations are present")
    }
    
    func testNegationWindow() {
        let result1 = analyzer.detect(in: "Definitivamente no me siento triste hoy")
        XCTAssertNotEqual(result1.state, .sad, "Should catch negation within 3-word window")
        
        let result2 = analyzer.detect(in: "Hace tiempo que no me sentía tan triste como hoy")
        XCTAssertEqual(result2.state, .sad, "Should detect sadness when negation is outside window")
    }
    
    // MARK: - Confidence Tests
    
    func testConfidenceScoring() {
        let highConfidenceText = "Me siento muy triste, deprimida y melancólica"
        let result1 = analyzer.detect(in: highConfidenceText)
        XCTAssertEqual(result1.state, .sad)
        XCTAssertGreaterThan(result1.confidence, 0.6, "High emotional density should yield high confidence")
        
        let lowConfidenceText = "Estoy algo triste"
        let result2 = analyzer.detect(in: lowConfidenceText)
        XCTAssertEqual(result2.state, .sad)
        XCTAssertLessThan(result2.confidence, 0.5, "Low emotional density should yield lower confidence")
    }
    
    func testNeutralConfidence() {
        let result = analyzer.detect(in: "Hoy es un día normal como cualquier otro")
        XCTAssertEqual(result.state, .neutral)
        XCTAssertEqual(result.confidence, 0.2, accuracy: 0.1, "Neutral text should have low confidence")
    }
    
    // MARK: - Priority Tests
    
    func testEmotionPriority() {
        // Anxious should take priority over excited in ties
        let result = analyzer.detect(in: "Me siento emocionada pero también ansiosa")
        XCTAssertEqual(result.state, .anxious, "Negative emotions should have priority in ties")
    }
    
    // MARK: - Rationale Tests
    
    func testRationaleInclusion() {
        let result = analyzer.detect(in: "Estoy muy agradecida por todo")
        XCTAssertTrue(result.rationale.contains("agradec"), "Rationale should include matched words")
        XCTAssertTrue(result.rationale.contains("score="), "Rationale should include score information")
    }
    
    // MARK: - Edge Cases
    
    func testEmptyText() {
        let result = analyzer.detect(in: "")
        XCTAssertEqual(result.state, .neutral)
        XCTAssertEqual(result.confidence, 0.2, accuracy: 0.1)
    }
    
    func testSpecialCharacters() {
        let result = analyzer.detect(in: "¡¡¡Estoy súper feliz!!! 😊🎉")
        XCTAssertEqual(result.state, .excited)
        XCTAssertGreaterThan(result.confidence, 0.3)
    }
    
    func testAccentHandling() {
        let result1 = analyzer.detect(in: "Estoy preocupada")
        let result2 = analyzer.detect(in: "Estoy preocupáda") // with accent
        
        XCTAssertEqual(result1.state, result2.state, "Accents should be handled consistently")
        XCTAssertEqual(result1.confidence, result2.confidence, accuracy: 0.1, "Confidence should be similar with/without accents")
    }
}
