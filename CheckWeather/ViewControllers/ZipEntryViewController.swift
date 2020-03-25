

import UIKit
import Combine

final class ZipEntryViewController: UIViewController {
    @IBOutlet weak var textField: ZipEntryTextField!
    @IBOutlet weak var OKButton: UIButton!
    
    var processor : ZipEntryProcessor?
    
    var pipelineStorage = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create processor and give it a coordinator
        let coordinator = ZipEntryCoordinator(viewController: self)
        self.processor = ZipEntryProcessor(coordinator: coordinator)
        // processor listens to text field and to our button signals
        self.processor?.preparePipeline(fromTextField: self.textField, viewController:self)
        // we listen to processor for validity of current zip, pipe to button enablement
        self.processor?.$validZip
            .sink {[unowned self] in self.OKButton.isEnabled = $0}
            .store(in: &pipelineStorage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder() // ready for text entry
    }
    
    // button methods poke subjects
    let userCancelled = PassthroughSubject<Bool,Never>()
    @IBAction func doCancel(_ sender: Any) {
        self.userCancelled.send(true)
    }
    let proposedZipCode = PassthroughSubject<String,Never>()
    @IBAction func doOK(_ sender: Any) {
        self.proposedZipCode.send(self.textField.text!)
    }

    deinit { print("farewell", self) }

}

