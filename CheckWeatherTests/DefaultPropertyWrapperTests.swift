import XCTest
@testable import CheckWeather

struct CrappyCodable : Codable {
    let prop = "Howdy"
    func encode(to encoder: Encoder) throws {
        enum Ouch : Error { case oops }
        throw Ouch.oops
    }
}

// test the `@Default` property wrapper
class DefaultPropertyWrapperTests: XCTestCase {
    
    @Default(key:"someString", defaultValue:"dowadiddydiddy")
    var defaultProperty
    let key = "someString"
    
    @Default(key:"someOtherString", defaultValue:CrappyCodable())
    var defaultProperty2
    let key2 = "someOtherString"

    // make sure the actual defaults is clear before and after testing
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: self.key)
        UserDefaults.standard.removeObject(forKey: self.key2)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: self.key)
        UserDefaults.standard.removeObject(forKey: self.key2)
    }

    func testDefaultsPropertyWrapper() {
        // default starts life empty
        XCTAssertEqual(self.defaultProperty,
                       "dowadiddydiddy",
                       "Default default should be dowadiddydiddy")
        XCTAssertNil(UserDefaults.standard.object(forKey: self.key),
                     "Actual default default should be nil")
        
        // pass thru property wrapper setter, give default a value
        self.defaultProperty = "howdy"
        XCTAssertEqual(self.defaultProperty,
                       "howdy",
                       "Default should be howdy")
        
        // look behind the curtain, the actual default should be a Data
        // (we cannot decode that here because Wrapper is rightly private)
        let data = UserDefaults.standard.object(forKey: self.key) as? Data
        XCTAssertNotNil(data,
                        "Actual default should be nonnil data")
        
        // deliberately screw up the actual default
        UserDefaults.standard.set(1, forKey: self.key)
        XCTAssertEqual(self.defaultProperty,
                       "dowadiddydiddy",
                       "If the actual default is not a data, we should get the default default")
        
        // deliberately screw up the actual default with wrong kind of data
        UserDefaults.standard.set(Data(), forKey: self.key)
        XCTAssertEqual(self.defaultProperty,
                       "dowadiddydiddy",
                       "If the actual default is data but not a wrapper, we should get the default default")
        
        // deliberately try to encode a screwed up encodable
        self.defaultProperty2 = CrappyCodable()
        // can't test that, but it does print "bad encodable" and completes our code coverage :)
    }

}
