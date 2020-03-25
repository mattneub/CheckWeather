
// model for DetailViewController
// we are given the detail data...
// ...and we vend formatted facts about it that the DetailViewController might want to know

import UIKit

class DetailViewData: NSObject {
    private let formatters : MyDateFormatters
    private let prediction : Prediction
    private let city : City
    init(prediction:Prediction, city:City, formatters:MyDateFormatters) {
        self.prediction = prediction
        self.city = city
        self.formatters = formatters
        super.init()
        self.cityName = self.city.name
        let start = self.formatters.wordyDateTimeFormatter.string(from: self.prediction.date)
        self.date = start
        self.temp = self.prediction.tempFormatted
        self.feels = self.prediction.tempFeelsLikeFormatted
        self.pressure = self.prediction.pressureFormatted
        self.humidity = self.prediction.humidityFormatted
        self.speed = self.prediction.wind.speedFormatted
        self.deg = self.prediction.wind.compassPoint
        self.clouds = self.prediction.cloudCoverFormatted
        self.rainOrSnow = self.prediction.precipFormatted
        self.main = self.prediction.weather?.generalDescription ?? ""
        self.desc = self.prediction.weather?.secondaryDescription ?? ""
        self.icon = self.prediction.weather?.image
    }

    // these are Optionals because of the way Swift key paths work
    // it's do-able if they are not Optionals, but the workaround is very messy,
    //  https://stackoverflow.com/questions/59637100/how-does-swift-referencewritablekeypath-work-with-an-optional-property
    
    @Published var cityName : String? = ""
    @Published var date : String? = ""
    @Published var temp : String? = ""
    @Published var feels : String? = ""
    @Published var pressure : String? = ""
    @Published var humidity : String? = ""
    @Published var speed : String? = ""
    @Published var deg : String? = ""
    @Published var clouds : String? = ""
    @Published var rainOrSnow : String? = ""
    @Published var main : String? = ""
    @Published var desc : String? = ""
    @Published var icon : UIImage? = nil

}
