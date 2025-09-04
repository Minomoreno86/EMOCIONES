import XCTest
@testable import ASISTENTE_APOYO_EMOCIONAL_FERTILIDAD

final class SafetyFilterTests: XCTestCase {
    
    var safetyFilter: SimpleSafetyFilter!
    
    override func setUp() {
        super.setUp()
        safetyFilter = SimpleSafetyFilter()
    }
    
    override func tearDown() {
        safetyFilter = nil
        super.tearDown()
    }
    
    // MARK: - Medical Language Filtering
    
    func testMedicalTermReplacement() {
        let input = "Debes tomar esta medicación para tu diagnóstico"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertFalse(filtered.contains("Debes "), "Should replace 'Debes' with softer language")
        XCTAssertTrue(filtered.contains("podrías considerar"), "Should use 'podrías considerar' instead")
        XCTAssertFalse(filtered.contains("medicación"), "Should replace medical terms")
    }
    
    func testDiagnosticLanguageFiltering() {
        let input = "Tu diagnóstico indica que tienes que ajustar dosis"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertFalse(filtered.contains("diagnóstico"), "Should filter diagnostic language")
        XCTAssertFalse(filtered.contains("tienes que"), "Should replace imperative language")
        XCTAssertFalse(filtered.contains("ajustar dosis"), "Should filter dosage instructions")
    }
    
    func testPrescriptiveLanguageReplacement() {
        let input = "Tienes que hacer esto y debes seguir esta receta"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertTrue(filtered.contains("podrías considerar"), "Should replace prescriptive language")
        XCTAssertFalse(filtered.contains("Tienes que"), "Should not contain original imperative")
        XCTAssertFalse(filtered.contains("debes"), "Should not contain original imperative")
    }
    
    // MARK: - Disclaimer Addition
    
    func testDisclaimerAddition() {
        let input = "Esto podría ayudarte con tu situación"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertTrue(filtered.contains("no sustituye"), "Should add disclaimer about not substituting professional help")
        XCTAssertTrue(filtered.contains("profesional de salud"), "Should mention health professional")
    }
    
    func testDisclaimerNotDuplicated() {
        let input = "Este apoyo no sustituye la evaluación de un profesional de salud."
        let filtered = safetyFilter.filter(input)
        
        let disclaimerCount = filtered.components(separatedBy: "no sustituye").count - 1
        XCTAssertEqual(disclaimerCount, 1, "Should not duplicate existing disclaimer")
    }
    
    func testAlternativeDisclaimerRecognition() {
        let input = "Consulta con tu profesional de salud para más información."
        let filtered = safetyFilter.filter(input)
        
        let disclaimerCount = filtered.components(separatedBy: "no sustituye").count - 1
        XCTAssertLessThanOrEqual(disclaimerCount, 1, "Should recognize existing health professional mention")
    }
    
    // MARK: - Case Insensitive Filtering
    
    func testCaseInsensitiveFiltering() {
        let input = "DEBES tomar esta MEDICACIÓN según el DIAGNÓSTICO"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertFalse(filtered.contains("DEBES"), "Should filter uppercase imperatives")
        XCTAssertTrue(filtered.contains("podrías considerar"), "Should replace with appropriate language")
    }
    
    // MARK: - Edge Cases
    
    func testEmptyString() {
        let filtered = safetyFilter.filter("")
        XCTAssertTrue(filtered.contains("no sustituye"), "Should add disclaimer even to empty string")
    }
    
    func testWhitespaceOnly() {
        let filtered = safetyFilter.filter("   ")
        XCTAssertTrue(filtered.contains("no sustituye"), "Should add disclaimer to whitespace-only string")
    }
    
    func testNoRiskyContent() {
        let input = "Te escucho y estoy aquí para apoyarte en este momento"
        let originalLength = input.count
        let filtered = safetyFilter.filter(input)
        
        XCTAssertTrue(filtered.hasPrefix(input), "Should preserve safe content")
        XCTAssertGreaterThan(filtered.count, originalLength, "Should add disclaimer to safe content")
    }
    
    // MARK: - Multiple Risk Terms
    
    func testMultipleRiskTerms() {
        let input = "Debes seguir el diagnóstico y ajustar dosis de la medicación según la receta"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertEqual(filtered.components(separatedBy: "podrías considerar").count - 1, 5, 
                      "Should replace all risky terms with safer alternatives")
    }
    
    // MARK: - Performance Tests
    
    func testFilteringPerformance() {
        let longText = String(repeating: "Debes tomar medicación según diagnóstico. ", count: 100)
        
        measure {
            _ = safetyFilter.filter(longText)
        }
    }
    
    // MARK: - Content Preservation
    
    func testContentMeaningPreservation() {
        let input = "Podrías considerar hablar con alguien sobre tus sentimientos"
        let filtered = safetyFilter.filter(input)
        
        XCTAssertTrue(filtered.contains("sentimientos"), "Should preserve emotional content")
        XCTAssertTrue(filtered.contains("hablar"), "Should preserve supportive suggestions")
    }
}
