

import UIKit
import Combine

final class DetailViewController : UIViewController {
    
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
    
    var pipelineStorage = Set<AnyCancellable>()
    
    private let data : DetailViewData
    
    init?(data:DetailViewData, coder:NSCoder) {
        self.data = data
        super.init(coder:coder)
    }
    // oh no you don't, _must_ call preceding initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure bindings from published properties of detail view data to our interface
        // hold my beer and watch _this!_
        // we pair the bindings with the display properties and loop over them to form the subscriptions
        typealias StringPub = Published<String?>.Publisher
        typealias OptStringPath = ReferenceWritableKeyPath<DetailViewController, String?>
        typealias PublisherPathPair = (StringPub, OptStringPath)
        let pairs : [PublisherPathPair] = [
            (self.data.$cityName, \DetailViewController.navigationItem.title),
            (self.data.$date, \DetailViewController.date.text),
            (self.data.$temp, \DetailViewController.temp.text),
            (self.data.$feels, \DetailViewController.feels.text),
            (self.data.$pressure, \DetailViewController.pressure.text),
            (self.data.$humidity, \DetailViewController.humidity.text),
            (self.data.$speed, \DetailViewController.speed.text),
            (self.data.$deg, \DetailViewController.deg.text),
            (self.data.$clouds, \DetailViewController.clouds.text),
            (self.data.$rainOrSnow, \DetailViewController.rainOrSnow.text),
            (self.data.$main, \DetailViewController.main.text),
            (self.data.$desc, \DetailViewController.desc.text),
        ]
        // (we don't really need `.store` for these onetime assignments,
        //  but it's good on principle)
        for (binding, path) in pairs {
            binding
                .sink { [unowned self] in self[keyPath:path] = $0 }
                .store(in: &self.pipelineStorage)
        }
        self.data.$icon
            .sink { [unowned self] in self.icon.image = $0 }
            .store(in:&self.pipelineStorage)
    }
    
    deinit { print("farewell", self) }
    
    
}
