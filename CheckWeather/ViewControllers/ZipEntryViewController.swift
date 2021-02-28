

import UIKit
import Combine

final class ZipEntryViewController: UIViewController {
    enum ZipEntryInterfaceEvent {
        case userChangedZip(String)
        case userSubmittedZip(String)
        case userCancelled
    }

    @IBOutlet weak var textField: ZipEntryTextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var processor : ZipEntryProcessor?
    var storage = Set<AnyCancellable>()
    
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
        self.textField.publisher(for: .editingChanged)
            .compactMap { $0 as? UITextField }
            .map { .userChangedZip($0.text ?? "") }
            .subscribe(self.interfaceEvent)
            .store(in: &self.storage)
        self.textField.publisher(for: .editingDidEndOnExit)
            .compactMap { $0 as? UITextField }
            .map { .userSubmittedZip($0.text ?? "") }
            .subscribe(self.interfaceEvent)
            .store(in: &self.storage)
        self.okButton.publisher()
            .map { [unowned self] _ in .userSubmittedZip(self.textField.text!) }
            .subscribe(self.interfaceEvent)
            .store(in: &self.storage)
        self.cancelButton.publisher()
            .map { _ in .userCancelled }
            .subscribe(self.interfaceEvent)
            .store(in: &self.storage)
//        // we listen to processor for validity of current zip, pipe to button enablement
        self.processor?.$validZip
            .sink {[unowned self] in self.okButton.isEnabled = $0}
            .store(in: &storage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder() // ready for text entry
    }
    
    deinit { print("farewell", self) }

}

