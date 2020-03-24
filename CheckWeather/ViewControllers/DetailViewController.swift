

import UIKit
import Combine

final class DetailViewController : UIViewController {
    private let data : DetailViewData
    init?(prediction:Prediction, city:City, formatters:MyDateFormatters, coder:NSCoder) {
        self.data = DetailViewData(prediction:prediction, city:city, formatters:formatters)
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
    
    var pipelineStorage = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure bindings from published properties of detail view data to our interface
        // hold my beer and watch _this_
        typealias StringPub = Published<String>.Publisher
        typealias OptStringPath = ReferenceWritableKeyPath<DetailViewController, String?>
        typealias MyTuple = (StringPub, OptStringPath)
        let pairs : [MyTuple] = [
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
        for (binding,path) in pairs {
            let pub : AnyPublisher<String?,Never> = binding.compactMap {$0}.eraseToAnyPublisher()
            let assign = Subscribers.Assign<DetailViewController,String?>(object: self, keyPath: path)
            pub.subscribe(assign)
            assign.store(in: &self.pipelineStorage)
        }
        self.data.$icon // odd man out, it's an image
            .assign(to: \.icon.image, on: self)
            .store(in:&self.pipelineStorage)
    }
    
    
}
