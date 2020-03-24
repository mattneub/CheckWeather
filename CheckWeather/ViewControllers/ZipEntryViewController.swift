

import UIKit
import Combine

final class ZipEntryViewController: UIViewController {
    @IBOutlet weak var textField: ZipEntryTextField!
    @IBOutlet weak var OKButton: UIButton!
    
    let coordinator = ZipEntryCoordinator()
    
    var pipelineStorage = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OKButton.isEnabled = false
        self.preparePipelines()
    }
    
    // called once as part of `viewDidLoad`, get ready to face user
    private func preparePipelines() {
        // five-digit-hood of text field flows directly into enablement of OK button
        self.textField.$hasFiveDigits
            .assign(to: \.isEnabled, on: self.OKButton)
            .store(in: &self.pipelineStorage)
        // signal that user has hit Return in text field, forward to coordinator
        self.textField.userHitReturn
            .sink {self.coordinator.weveGotAZipCode($0, in: self)}
            .store(in: &self.pipelineStorage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder() // ready for text entry
    }
    
    // user cancelled, forward to coordinator
    @IBAction func doCancel(_ sender: Any) {
        self.coordinator.userCancelled(self)
    }
        
    // user tapped OK, forward to coordinator
    @IBAction func doOK(_ sender: Any) {
        self.coordinator.weveGotAZipCode(self.textField.text!, in: self)
    }

}

