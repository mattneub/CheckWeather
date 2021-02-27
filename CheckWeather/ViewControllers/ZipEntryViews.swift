
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
    deinit { print("farewell", type(of:self)) }
}

/// Text field for zip entry, can only enter numbers
class ZipEntryTextField : UITextField, UITextFieldDelegate {
            
    // I am my own delegate
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.configure()
    }
    private func configure() {
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
        if string == "\n" { // allow return character
            return true
        }
        let isNumber = string.allSatisfy {
            "01234567890".contains($0)
        }
        return isNumber
    }
    
    
    deinit { print("farewell", type(of:self)) }

}
