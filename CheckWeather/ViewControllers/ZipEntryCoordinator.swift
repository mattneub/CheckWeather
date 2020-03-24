

import UIKit

// mild coordinator for ZipEntryViewController
// our job is to know that this is a presented view controller
// and to send info back on dismissal

class ZipEntryCoordinator: NSObject {
    
    func userCancelled(_ vc:UIViewController) {
        vc.dismiss(animated: true)
    }
    
    func weveGotAZipCode(_ zip:String, in vc:UIViewController) {
        self.dismissAndAnnounceNewZipCode(zip, in:vc)
    }
    
    private func dismissAndAnnounceNewZipCode(_ zip:String, in vc:UIViewController) {
        vc.dismiss(animated: true) {
            self.announceNewZipCode(zip)
        }
    }
    
    // communication (back to MasterViewController) is by notification
    // make this a static property (nice namespacing)
    
    static let zipCodeDidChange = Notification.Name("zipCodeDidChange")
    private func announceNewZipCode(_ zip:String) {
        NotificationCenter.default.post(
            name: Self.zipCodeDidChange,
            object: self,
            userInfo: ["zip":zip]
        )
    }

}
