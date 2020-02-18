

import UIKit

// utility view classes

// appears at top of both pages
final class Backdrop : UIView {
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.backgroundColor = .secondarySystemBackground
    }
}

// appears in second page
// COOL FEATURE: how to get small caps version of system font, cute eh
final class SmallCapsLabel : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let font = UIFont.systemFont(ofSize: 17)
        let desc = font.fontDescriptor
        let d = [
            UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
        ]
        let desc2 = desc.addingAttributes([.featureSettings:[d]])
        let f = UIFont(descriptor: desc2, size: 0)
        self.font = f
    }
}
