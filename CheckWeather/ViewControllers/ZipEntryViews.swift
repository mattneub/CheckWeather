
import UIKit
import Combine

// views associated with ZipEntryViewController

// overall view for ZipEntryViewController, nice look with rounded border

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
    
    deinit { print("farewell", self) }


}

// text field for ZipEntryViewController, can only enter numbers

class ZipEntryTextField : UITextField, UITextFieldDelegate {
    
    // I am my own delegate (always something a little weird-feeling about this)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.delegate = self
    }
    
    // COOL FEATURE: use Combine framework publishers to let client (view controller) hear what's happened
    // hasFiveDigits always tracks the five-digit-hood of this text field
    // userHitReturn is signal that user used keyboard to signal completion
    
    @Published var hasFiveDigits = false
    let userHitReturn = PassthroughSubject<String,Never>()
        
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
    
    // _five_ digits, please
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.hasFiveDigits = self.text!.count == 5
    }
    
    // external keyboard return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.hasFiveDigits {
            self.userHitReturn.send(self.text!)
        }
        return false
    }
    
    deinit { print("farewell", self) }

}
