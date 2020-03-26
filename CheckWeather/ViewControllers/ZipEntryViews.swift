
import UIKit
import Combine

// views associated with ZipEntryViewController


/// Background view with nice rounded border
class ZipEntryView: UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.initiallyConfigure()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.initiallyConfigure()
    }
    private func initiallyConfigure() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 3
    }
    // debugging memory management
    deinit { print("farewell", self) }
}

/// Text field for zip entry, can only enter numbers
class ZipEntryTextField : UITextField, UITextFieldDelegate {
    
    let userHitReturn = PassthroughSubject<String,Never>()
    let userChangedText = PassthroughSubject<String,Never>()
        
    // I am my own delegate
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.delegate = self
    }
    
    // digits only, please
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
    
    // publish change of text
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.userChangedText.send(self.text!)
    }
    
    // external keyboard return key, publish change of text, keyboard dismisses
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userHitReturn.send(self.text!)
        return false
    }
    
    deinit { print("farewell", self) }

}
