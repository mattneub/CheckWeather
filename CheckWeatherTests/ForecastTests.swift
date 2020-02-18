
import XCTest
@testable import CheckWeather

// test those areas of the Forecast where I'm using my own algorithm
class ForecastTests: XCTestCase {

    // boxing the compass, test our conversion of integer degrees to (half)wind name
    // points are every 22.5 degree = 11.25 on each side of the actual point
    // see https://en.wikipedia.org/wiki/Points_of_the_compass#16-wind_compass_rose
    // the divides are at the middle azimuth of the "by" points of the 32-wind rose
    func testWindDirection() {
        XCTAssertEqual(Wind(speed:0, deg:11).compassPoint, "N")
        XCTAssertEqual(Wind(speed:0, deg:12).compassPoint, "NNE")
        XCTAssertEqual(Wind(speed:0, deg:33).compassPoint, "NNE")
        XCTAssertEqual(Wind(speed:0, deg:34).compassPoint, "NE")
        XCTAssertEqual(Wind(speed:0, deg:56).compassPoint, "NE")
        XCTAssertEqual(Wind(speed:0, deg:57).compassPoint, "ENE")
        XCTAssertEqual(Wind(speed:0, deg:78).compassPoint, "ENE")
        XCTAssertEqual(Wind(speed:0, deg:79).compassPoint, "E")
        XCTAssertEqual(Wind(speed:0, deg:101).compassPoint, "E")
        XCTAssertEqual(Wind(speed:0, deg:102).compassPoint, "ESE")
        XCTAssertEqual(Wind(speed:0, deg:123).compassPoint, "ESE")
        XCTAssertEqual(Wind(speed:0, deg:124).compassPoint, "SE")
        XCTAssertEqual(Wind(speed:0, deg:146).compassPoint, "SE")
        XCTAssertEqual(Wind(speed:0, deg:147).compassPoint, "SSE")
        XCTAssertEqual(Wind(speed:0, deg:168).compassPoint, "SSE")
        XCTAssertEqual(Wind(speed:0, deg:169).compassPoint, "S")
        XCTAssertEqual(Wind(speed:0, deg:191).compassPoint, "S")
        XCTAssertEqual(Wind(speed:0, deg:192).compassPoint, "SSW")
        XCTAssertEqual(Wind(speed:0, deg:213).compassPoint, "SSW")
        XCTAssertEqual(Wind(speed:0, deg:214).compassPoint, "SW")
        XCTAssertEqual(Wind(speed:0, deg:236).compassPoint, "SW")
        XCTAssertEqual(Wind(speed:0, deg:237).compassPoint, "WSW")
        XCTAssertEqual(Wind(speed:0, deg:258).compassPoint, "WSW")
        XCTAssertEqual(Wind(speed:0, deg:259).compassPoint, "W")
        XCTAssertEqual(Wind(speed:0, deg:281).compassPoint, "W")
        XCTAssertEqual(Wind(speed:0, deg:282).compassPoint, "WNW")
        XCTAssertEqual(Wind(speed:0, deg:303).compassPoint, "WNW")
        XCTAssertEqual(Wind(speed:0, deg:304).compassPoint, "NW")
        XCTAssertEqual(Wind(speed:0, deg:326).compassPoint, "NW")
        XCTAssertEqual(Wind(speed:0, deg:327).compassPoint, "NNW")
        XCTAssertEqual(Wind(speed:0, deg:348).compassPoint, "NNW")
        XCTAssertEqual(Wind(speed:0, deg:349).compassPoint, "N")
    }
    
    // test our derivation of when given day starts _at the target location_
    func testStartOfDay() {
        for offset in 0...8 { // no point overdoing it, app only works for US time zones anyway
            let tz = -offset*60*60
            let cal = Calendar(identifier:.gregorian)
            let city : City = City(name: "Whoville", country: "", coord: City.Coord(lon: 10, lat: 10), timezone: tz, id: nil)
            let forecast : Forecast = Forecast(city:city, predictions:[])
            let pred : Prediction = Prediction(date: Date(), wind: Wind(speed:2, deg:2), temp: 300, feels: 300, pressure: 30, humidity: 30)
            let start = forecast.startOfDay(for:pred) // this is what we are testing
            let comp = cal.dateComponents(in: TimeZone(secondsFromGMT: tz)!, from: start)
            XCTAssertEqual(comp.hour, 0, "hour should be 0")
            XCTAssertEqual(comp.minute, 0, "minute should be 0")
        }
    }

    // test our display of precipitation amount
    func testPrecipFormatted() {
        // precipitation should be reported as zero
        // unless there is rain, in which case the rain should be reported
        // or there is snow, in which case the snow should be reported
        // if there is both, I report rain only
        do {
            let pred : Prediction = Prediction(
                date: Date(), wind: Wind(speed:2, deg:2), temp: 300, feels: 300, pressure: 30, humidity: 30)
            let meas = Measurement(value: 0, unit: UnitLength.millimeters).converted(to: .inches)
            XCTAssertEqual(pred.precipFormatted, Forecast.publicPrecipFormatter.string(from:meas))
        }
        do {
            let pred : Prediction = Prediction(
                date: Date(), wind: Wind(speed:2, deg:2), temp: 300, feels: 300, pressure: 30, humidity: 30, rain:26)
            let meas = Measurement(value: 26, unit: UnitLength.millimeters).converted(to: .inches)
            XCTAssertEqual(pred.precipFormatted, Forecast.publicPrecipFormatter.string(from:meas))
        }
        do {
            let pred : Prediction = Prediction(
                date: Date(), wind: Wind(speed:2, deg:2), temp: 300, feels: 300, pressure: 30, humidity: 30, snow:52)
            let meas = Measurement(value: 52, unit: UnitLength.millimeters).converted(to: .inches)
            XCTAssertEqual(pred.precipFormatted, Forecast.publicPrecipFormatter.string(from:meas))
        }
        do {
            let pred : Prediction = Prediction(
                date: Date(), wind: Wind(speed:2, deg:2), temp: 300, feels: 300, pressure: 30, humidity: 30, rain:26, snow:52)
            let meas = Measurement(value: 26, unit: UnitLength.millimeters).converted(to: .inches)
            XCTAssertEqual(pred.precipFormatted, Forecast.publicPrecipFormatter.string(from:meas))
        }

    }
}
