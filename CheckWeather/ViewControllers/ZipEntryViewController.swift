

import UIKit

// communication back to MasterViewController is by notification
// I tend to put notification names in the file containing the class that "vends" them
// could alternatively make this a static property of the class itself (nicer namespacing)
extension Notification.Name {
    static let zipCodeDidChange = Notification.Name("zipCodeDidChange")
}

final class ZipEntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var OKButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OKButton.isEnabled = false
        self.view.layer.borderWidth = 2
        self.view.layer.cornerRadius = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder() // ready for text entry
    }
    
    // digits only please
    func textField(_ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool
    {
        if string.isEmpty { // backspace
            return true
        }
        let isNumber = string.allSatisfy {
            "01234567890".contains($0)
        }
        return isNumber
    }
    
    // five digits please
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.OKButton.isEnabled = textField.text!.count == 5
    }
    
    // external keyboard return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.OKButton.isEnabled {
            self.doOK(self)
        }
        return false
    }
    
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doOK(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(
                name: .zipCodeDidChange,
                object: self,
                userInfo: ["zip":self.textField.text!]
            )
        }
    }
    
}

