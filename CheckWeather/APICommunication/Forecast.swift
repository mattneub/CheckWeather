

import UIKit

// this is the data object, Forecast, derived from the JSON response
// along with formatters to stringify its data for presentation

// probably the most controversial thing in the whole code,
// I had a big philosophical argument with myself:
// who should _format_ the data?
// in the end, I put the formatters _in the data object_
// so for example we contain a (private) `pressure` value
// and we contain a (public) `pressureFormatted` computed variable
// that uses the PressureFormatter

// but is that an MVC violation?
// you might argue that the model data should be _just_ data
// but then where should the formatters etc. live?
// I didn't want them cluttering up the view controllers
// ideally there might be some Third Way where there is
// yet another object that formats the data (VIPER? no idea)

// =======================
// MARK: formatter classes

fileprivate final class MyDegreeMeasurementFormatter : MeasurementFormatter {
    override init() {
        super.init()
        let n = NumberFormatter()
        n.numberStyle = .none // integer representation
        self.numberFormatter = n
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func stringFromCelsius(_ celsius : Double) -> String { // unused, we _could_ ask for degrees in celsius but I don't
        let measurement = Measurement(value: celsius, unit: UnitTemperature.celsius)
        return self.string(from: measurement)
    }
    func stringFromKelvin(_ kelvin : Double) -> String {
        let measurement = Measurement(value: kelvin, unit: UnitTemperature.kelvin)
        return self.string(from: measurement)
    }
}

// formatters are expensive to create
// so the init is fileprivate so that only a Forecast can make one
// the view controllers have to access that and pass it around
final class MyDateFormatters {
    let dateTimeFormatter : DateFormatter
    let dateFormatter : DateFormatter
    let wordyDateFormatter : DateFormatter
    let wordyDateTimeFormatter : DateFormatter
    let timeFormatter : DateFormatter
    fileprivate init(timeZone tz:TimeZone?) {
        func formatterForTemplate(_ s:String) -> DateFormatter {
            let df = DateFormatter()
            df.locale = Locale.current
            df.timeZone = tz // this is the important thing: times are shown _at the target location_
            df.setLocalizedDateFormatFromTemplate(s)
            return df
        }
        self.dateTimeFormatter = formatterForTemplate("EEMdy hhmm")
        self.dateFormatter = formatterForTemplate("MMddy")
        self.wordyDateFormatter = formatterForTemplate("EEEEMMMMdy")
        self.wordyDateTimeFormatter = formatterForTemplate("EEEEMMMMdyhhmm")
        self.timeFormatter = formatterForTemplate("hhmm")
    }
}

// ==================
// MARK: data holders

// this is what actually arrives from the API!
// the outer wrapper is a _class_ so that we can always have just one with multiple references to it
final class Forecast : Decodable {
    let city : City
    let predictions : [Prediction]
    // COOL FEATURE: test configuration!
    // "Testing" is a project Configuration, identical to "Debug" except that it has an active compilation condition TESTING
    // and our Scheme declares that the Test action uses the Testing configuration
    // therefore `#if TESTING` does conditional compilation only for unit test compilations:
    // these testability initializers are thus not exposed to the app's own code!
    // they exist only when you say Product > Build For > Testing or Product > Test or otherwise actually run a test
    #if TESTING
    init(city:City, predictions:[Prediction]) { // for testability
        self.city = city
        self.predictions = predictions
    }
    #endif
    func startOfDay(for pred:Prediction) -> Date {
        var greg = Calendar(identifier: .gregorian)
        greg.timeZone = self.city.timezoneStruct! // slick trick
        return greg.startOfDay(for: pred.date)
    }
    // formatters are expensive to create, so create lazily and maintain
    // the date formatters accompany this instance because their definition depends upon the City time zone
    // public! view controllers need to be able to pick a date formatter
    lazy var formatters = MyDateFormatters(timeZone: self.city.timezoneStruct)
    // the other formatters have no dependencies so they can be static (which is still lazy)
    // makes for easy access from embedded structs
    fileprivate static let pressureFormatter : MeasurementFormatter = {
        let pressureFormatter = MeasurementFormatter()
        let pressureNumberFormatter = NumberFormatter()
        pressureNumberFormatter.maximumFractionDigits = 1
        pressureFormatter.numberFormatter = pressureNumberFormatter
        return pressureFormatter
    }()
    fileprivate static let speedFormatter : MeasurementFormatter =  {
        let speedFormatter = MeasurementFormatter()
        let speedNumberFormatter = NumberFormatter()
        speedNumberFormatter.numberStyle = .none // integer representation
        speedFormatter.numberFormatter = speedNumberFormatter
        return speedFormatter
    }()
    fileprivate static let precipFormatter : MeasurementFormatter = {
        let precipFormatter = MeasurementFormatter()
        precipFormatter.unitOptions = .providedUnit
        let precipNumberFormatter = NumberFormatter()
        precipNumberFormatter.maximumFractionDigits = 1
        precipFormatter.numberFormatter = precipNumberFormatter
        return precipFormatter
    }()
    #if TESTING
    static let publicPrecipFormatter = precipFormatter
    #endif
    enum CodingKeys : String, CodingKey {
        case city
        case predictions = "list"
    }
}

struct City : Decodable {
    struct Coord : Decodable {
        let lon : Double
        let lat : Double
    }
    let name : String
    let country : String
    let coord : Coord
    let timezone : Int // shift in seconds from UTC
    var timezoneStruct : TimeZone? { TimeZone(secondsFromGMT: self.timezone) } // formal timezone object
    let id : Int?
}

// one prediction is a three-hour stretch
struct Prediction : Decodable, Hashable {
    let date : Date // start of forecast period
    // a Prediction is considered hashable and equatable solely on its date
    // because after all you won't get two for the same date
    // this allows us to use the diffable data source!
    static func ==(lhs:Prediction,rhs:Prediction) -> Bool {
        return lhs.date == rhs.date
    }
    func hash(into hasher: inout Hasher) {
        date.hash(into:&hasher)
    }
    #if TESTING
    init(date:Date, wind:Wind, temp:Double, feels:Double, pressure: Int, humidity: Int, rain:Double?=nil, snow:Double?=nil) { // for testability
        self.date = date
        self.rain = rain == nil ? nil : Rain(volume:rain!)
        self.snow = snow == nil ? nil : Snow(volume:snow!)
        self.clouds = Clouds(all: 0)
        self.weathers = [Weather(gen: "Lousy", sec: "Crappy", icon: "99")]
        self.wind = wind
        self.main = Main(temp: temp, tempFeelsLike: feels, pressure: pressure, humidity: humidity)
    }
    #endif
    // "main" is embedded JSON dict, use computed vars to hide
    private let main : Main
    private static let formatter = MyDegreeMeasurementFormatter()
    private func tempFormatted(_ d:Double) -> String {
        return Self.formatter.stringFromKelvin(d)
    }
    var tempFormatted : String { self.tempFormatted(self.main.temp) }
    var tempFeelsLikeFormatted : String { self.tempFormatted(self.main.tempFeelsLike) }
    var pressureFormatted : String { self.main.pressureFormatted }
    var humidityFormatted : String { self.main.humidityFormatted }
    // wind is completely exposed
    let wind : Wind
    // weathers hidden, first entry is exposed
    // (don't know why this is an array in the JSON, as there is always exactly one)
    private let weathers : [Weather]
    var weather : Weather? { weathers.first }
    // clouds, rain, snow hidden, inner values exposed
    private let clouds : Clouds
    var cloudCoverFormatted : String { String(self.clouds.all) + "%" }
    private let rain : Rain?
    private let snow : Snow?
    var precipFormatted : String {
        let rainOrSnow : Double = self.rain?.volume ?? self.snow?.volume ?? 0
        let precipMeasure = Measurement(value: rainOrSnow, unit: UnitLength.millimeters).converted(to: .inches)
        return Forecast.precipFormatter.string(from:precipMeasure)
    }
    enum CodingKeys : String, CodingKey {
        case date = "dt"
        case main
        case wind
        case weathers = "weather"
        case clouds
        case rain
        case snow
    }
}

fileprivate struct Main : Decodable {
    let temp : Double // Kelvin
    let tempFeelsLike : Double
    let pressure : Int // in hPa
    var pressureFormatted : String {
        let pressureMeasure = Measurement(
            value: Double(self.pressure),
            unit: UnitPressure.hectopascals)
        return Forecast.pressureFormatter.string(from:pressureMeasure)
    }
    let humidity : Int // in %
    var humidityFormatted : String { String(self.humidity) + "%" }
    enum CodingKeys : String, CodingKey {
        case temp
        case tempFeelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct Wind : Decodable {
    fileprivate let speed : Double // meter per sec
    var speedFormatted : String {
        let speedMeasure = Measurement(
            value: self.speed,
            unit: UnitSpeed.metersPerSecond)
        return Forecast.speedFormatter.string(from:speedMeasure)
    }
    fileprivate let deg : Int // wind direction in meteorological degrees
    var compassPoint : String {
        let points = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"]
        return points[Int(Double(self.deg)/22.5+0.5) % 16] // ripped off from StackOverflow
    }
    #if TESTING
    init(speed:Double, deg:Int) {
        self.speed = speed
        self.deg = deg
    }
    var degTesting : Int { self.deg }
    #endif
}

fileprivate struct Clouds : Decodable {
    let all:Int // in %
}

fileprivate struct Rain : Decodable {
    let volume:Double // mm
    enum CodingKeys : String, CodingKey {
        case volume = "3h"
    }
}

fileprivate struct Snow : Decodable {
    let volume:Double // mm
    enum CodingKeys : String, CodingKey {
        case volume = "3h"
    }
}

struct Weather : Decodable {
    // let id : Int
    let generalDescription : String
    let secondaryDescription : String
    private let icon : String
    #if TESTING
    init(gen:String, sec:String, icon:String) { // for testability
        self.generalDescription = gen
        self.secondaryDescription = sec
        self.icon = icon
    }
    #endif
    // let's use cool new iOS 13 "symbol images"
    // I did include openweathermap's own icons, but decided not to use them
    private let imageNameDictionary : [String:String] = [
        "01d": "sun.max",
        "01n": "moon.stars",
        "02d": "cloud.sun",
        "02n": "cloud.moon",
        "03d": "cloud",
        "03n": "cloud.moon",
        "04d": "cloud.fill",
        "04n": "cloud.moon.fill",
        "13d": "snow",
        "13n": "snow",
        "11d": "cloud.bolt.rain",
        "11n": "cloud.moon.bolt",
        "09d": "cloud.drizzle",
        "09n": "cloud.moon.rain",
        "10d": "cloud.heavyrain",
        "10n": "cloud.moon.rain.fill",
        "50d": "cloud.fog.fill",
        "50n": "cloud.fog.fill"
    ]
    var image : UIImage? {
        if let im = imageNameDictionary[self.icon] {
            return UIImage(systemName:im)
        } else {
            return nil
        }
    }
    enum CodingKeys : String, CodingKey {
        case generalDescription = "main"
        case secondaryDescription = "description"
        case icon
    }
}

// images work like this (day variants shown):
// Clear : 01d
// Clouds : under 25%, 02d
// Clouds : under 50%, 03d
// Clouds : otherwise, 04d
// Snow : 13d
// Thunderstorm : 11d
// Drizzle : 09d
// Rain : 10d (I'm simplifying)
// Otherwise 50d

