

import UIKit

// what this app does: presents free openweathermap API data,
// five day forecast at three-hour intervals

// known limitations:
// interface is iPhone only, portrait only
// iOS 13 only (I've taken advantage of lots of cool iOS 13 features)
// bonus: dark mode compatible!

// cool features are marked COOL FEATURE (heh heh)

// ==============

// I tend to put globals and utility extensions in app delegate

struct DefaultKeys {
    static let json = "json"
    static let zip = "zip"
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}

// see my answer at https://stackoverflow.com/a/24318861/341994
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// COOL FEATURE: new in Swift 5.1, property wrappers
// see my answer at https://stackoverflow.com/a/59475086/341994
@propertyWrapper
struct Default<T: Codable> {
    private struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data
                else { return defaultValue }
            let value = try? PropertyListDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(Wrapper(wrapped:newValue))
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("bad encodable")
            }
        }
    }
}

// =============

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}

