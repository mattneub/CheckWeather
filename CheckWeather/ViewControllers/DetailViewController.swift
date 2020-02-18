

import UIKit

final class DetailViewController : UIViewController {
    private let formatters : MyDateFormatters
    private let prediction : Prediction
    private let city : City
    init?(prediction:Prediction, city:City, formatters:MyDateFormatters, coder:NSCoder) {
        self.prediction = prediction
        self.city = city
        self.formatters = formatters
        super.init(coder:coder)
    }
    // _must_ call preceding initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var temp: UILabel!
    @IBOutlet private weak var feels: UILabel!
    @IBOutlet private weak var main: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var speed: UILabel!
    @IBOutlet private weak var deg: UILabel!
    @IBOutlet private weak var clouds: UILabel!
    @IBOutlet private weak var rainOrSnow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // populate ourselves directly from the City and Prediction
        self.navigationItem.title = self.city.name
        let start = self.formatters.wordyDateTimeFormatter.string(from: self.prediction.date)
        self.date.text = start
        self.temp.text = self.prediction.tempFormatted
        self.feels.text = self.prediction.tempFeelsLikeFormatted
        self.pressure.text = self.prediction.pressureFormatted
        self.humidity.text = self.prediction.humidityFormatted
        self.speed.text = self.prediction.wind.speedFormatted
        self.deg.text = self.prediction.wind.compassPoint
        self.clouds.text = self.prediction.cloudCoverFormatted
        self.rainOrSnow.text = self.prediction.precipFormatted
        self.main.text = self.prediction.weather?.generalDescription
        self.desc.text = self.prediction.weather?.secondaryDescription
        self.icon.image = self.prediction.weather?.image
    }
    
    
}
