
import XCTest
@testable import CheckWeather

// test the way we populate the table view based on the array of predictions
// should clump predictions coherently into sections
class TablePopulationTests: XCTestCase {
    
    // construct testing data
    let offsetInHours = 4 // or whatever
    var mockForecast : Forecast!
    
    override func setUp() {
        let tz = -self.offsetInHours*60*60
        let city = City(name: "Whoville", country: "", coord: City.Coord(lon: 0, lat: 0), timezone: tz, id: nil)
        var predictions = [Prediction]()
        let greg = Calendar(identifier: .gregorian)
        for i in (1...100) {
            // successive predictions dated at successive hours
            let dc = DateComponents(year: 2020, month: 8, day: 10, hour: i, minute: 0, second: 0)
            let date = greg.date(from:dc)!
            // tag with our counter
            let pred = Prediction(date: date, wind: Wind(speed:0, deg:i), temp: 300, feels: 300, pressure: 30, humidity: 0)
            predictions.append(pred)
        }
        let forecast = Forecast(city:city, predictions:predictions)
        self.mockForecast = forecast
    }
    
    func testPopulation() {
        // populate the table data source
        let ds = MasterViewTableDataSource(tableView: UITableView())
        ds.populate(from: self.mockForecast)
        
        // now examine what we've got
        let snap = ds.snapshot()
        
        let sections = snap.sectionIdentifiers
        XCTAssertEqual(sections.count,
                       5,
                       "there should be five sections")
        
        let countFirst = snap.numberOfItems(inSection:sections[0])
        XCTAssertEqual(countFirst,
                       24-self.offsetInHours,
                       "first section should be offset")
        
        let countSecond = snap.numberOfItems(inSection:sections[1])
        XCTAssertEqual(countSecond,
                       24,
                       "subsequent sections should contain 24 predictions")
        // no need to test the others
        
        let allItems = snap.itemIdentifiers
        let tags = allItems.map {$0.wind.degTesting}
        XCTAssertEqual(tags,
                       Array(1...100),
                       "all predictions should be present in order")
    }
    
}
