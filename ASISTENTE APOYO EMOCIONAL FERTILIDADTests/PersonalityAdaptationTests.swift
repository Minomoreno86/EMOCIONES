import XCTest
@testable import ASISTENTE_APOYO_EMOCIONAL_FERTILIDAD

final class PersonalityAdaptationTests: XCTestCase {
    
    var adapter: ClampedPersonalityAdapter!
    var traits: PersonalityTraits!
    
    override func setUp() {
        super.setUp()
        adapter = ClampedPersonalityAdapter()
        traits = PersonalityTraits()
    }
    
    override func tearDown() {
        adapter = nil
        traits = nil
        super.tearDown()
    }
    
    // MARK: - Clamping Tests
    
    func testPersonalityClamp() {
        // Test that values stay within 0...1 bounds
        traits.empathy = 0.95
        
        // Adapt multiple times to anxious emotion
        for _ in 0..<20 {
            adapter.adapt(to: .anxious, traits: &traits)
        }
        
        XCTAssertLessThanOrEqual(traits.empathy, 1.0, "Empathy should not exceed 1.0")
        XCTAssertGreaterThanOrEqual(traits.empathy, 0.0, "Empathy should not go below 0.0")
        XCTAssertLessThanOrEqual(traits.supportiveness, 1.0, "Supportiveness should not exceed 1.0")
        XCTAssertGreaterThanOrEqual(traits.supportiveness, 0.0, "Supportiveness should not go below 0.0")
    }
    
    func testLowerBoundClamping() {
        traits.empathy = 0.05
        
        // Try to decrease below 0
        for _ in 0..<20 {
            adapter.adapt(to: .neutral, traits: &traits) // neutral should regress towards baseline
        }
        
        XCTAssertGreaterThanOrEqual(traits.empathy, 0.0, "Empathy should not go below 0.0")
    }
    
    // MARK: - Adaptation Logic Tests
    
    func testAnxiousAdaptation() {
        let initialEmpathy = traits.empathy
        let initialSupport = traits.supportiveness
        
        adapter.adapt(to: .anxious, traits: &traits)
        
        XCTAssertGreaterThan(traits.empathy, initialEmpathy, "Empathy should increase for anxious emotions")
        XCTAssertGreaterThan(traits.supportiveness, initialSupport, "Supportiveness should increase for anxious emotions")
    }
    
    func testSadAdaptation() {
        let initialEmpathy = traits.empathy
        
        adapter.adapt(to: .sad, traits: &traits)
        
        XCTAssertGreaterThan(traits.empathy, initialEmpathy, "Empathy should increase for sad emotions")
    }
    
    func testFrustratedAdaptation() {
        let initialIntuition = traits.intuition
        
        adapter.adapt(to: .frustrated, traits: &traits)
        
        XCTAssertGreaterThan(traits.intuition, initialIntuition, "Intuition should increase for frustrated emotions")
    }
    
    func testHopefulAdaptation() {
        let initialHopefulness = traits.hopefulness
        
        adapter.adapt(to: .hopeful, traits: &traits)
        
        XCTAssertGreaterThan(traits.hopefulness, initialHopefulness, "Hopefulness should increase for hopeful emotions")
    }
    
    func testGratefulAdaptation() {
        let initialSupport = traits.supportiveness
        
        adapter.adapt(to: .grateful, traits: &traits)
        
        XCTAssertGreaterThan(traits.supportiveness, initialSupport, "Supportiveness should increase for grateful emotions")
    }
    
    // MARK: - Neutral Regression Tests
    
    func testNeutralRegression() {
        // Set traits away from baseline
        traits.empathy = 0.95
        traits.supportiveness = 0.95
        traits.intuition = 0.95
        traits.hopefulness = 0.95
        
        // Apply neutral adaptation multiple times
        for _ in 0..<100 {
            adapter.adapt(to: .neutral, traits: &traits)
        }
        
        // Should regress towards baseline values
        XCTAssertLessThan(traits.empathy, 0.95, "Empathy should regress from extreme values")
        XCTAssertEqual(traits.empathy, 0.8, accuracy: 0.1, "Empathy should approach baseline (0.8)")
        XCTAssertEqual(traits.supportiveness, 0.7, accuracy: 0.1, "Supportiveness should approach baseline (0.7)")
        XCTAssertEqual(traits.intuition, 0.6, accuracy: 0.1, "Intuition should approach baseline (0.6)")
        XCTAssertEqual(traits.hopefulness, 0.9, accuracy: 0.1, "Hopefulness should approach baseline (0.9)")
    }
    
    // MARK: - Delta Consistency Tests
    
    func testConsistentDelta() {
        let initialEmpathy = traits.empathy
        
        adapter.adapt(to: .anxious, traits: &traits)
        let firstDelta = traits.empathy - initialEmpathy
        
        traits.empathy = initialEmpathy // Reset
        adapter.adapt(to: .anxious, traits: &traits)
        let secondDelta = traits.empathy - initialEmpathy
        
        XCTAssertEqual(firstDelta, secondDelta, accuracy: 0.001, "Delta should be consistent for same emotion")
    }
    
    // MARK: - Performance Tests
    
    func testAdaptationPerformance() {
        measure {
            for i in 0..<1000 {
                let emotion: EmotionalState = [.anxious, .sad, .hopeful, .excited, .frustrated, .grateful, .neutral][i % 7]
                adapter.adapt(to: emotion, traits: &traits)
            }
        }
    }
}
