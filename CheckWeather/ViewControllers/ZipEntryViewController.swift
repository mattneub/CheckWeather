

import UIKit
import Combine

final class ZipEntryViewController: UIViewController {
    enum ZipEntryInterfaceEvent {
        case userChangedZip(String)
        case userFinishedZip(String)
        case userCancelled
    }

    @IBOutlet weak var textField: ZipEntryTextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var processor : ZipEntryProcessor?
    var pipelineStorage = Set<AnyCancellable>()
    
    // signal that something happened in interface
    let interfaceEvent = PassthroughSubject<ZipEntryInterfaceEvent,Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create processor and give it a coordinator
        // coordinator will dismiss us
        let coordinator = ZipEntryCoordinator(viewController: self)
        // processor will listen to our button signals
        self.processor = ZipEntryProcessor(coordinator: coordinator, viewController: self)
        // we listen to interface and signal changes for processor
        self.textField.userChangedText
            .sink {[unowned self] in self.interfaceEvent.send(.userChangedZip($0))}
            .store(in: &self.pipelineStorage)
        self.textField.userHitReturn
            .sink {[unowned self] in self.interfaceEvent.send(.userFinishedZip($0))}
            .store(in: &self.pipelineStorage)
        self.okButton.publisher()
            .sink {[unowned self] _ in self.interfaceEvent.send(.userFinishedZip(self.textField.text!))}
            .store(in: &self.pipelineStorage)
        self.cancelButton.publisher()
            .sink {[unowned self] _ in self.interfaceEvent.send(.userCancelled)}
            .store(in: &self.pipelineStorage)
        // we listen to processor for validity of current zip, pipe to button enablement
        self.processor?.$validZip
            .sink {[unowned self] in self.okButton.isEnabled = $0}
            .store(in: &pipelineStorage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder() // ready for text entry
    }
    
    deinit { print("farewell", self) }

}

