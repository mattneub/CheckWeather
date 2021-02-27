

import UIKit
import Combine

extension Character {
    var isDigit : Bool {
        Set(Array("1234567890")).contains(self)
    }
}

/// Business logic for zip entry.
/// Listen for signal from interface.
/// Signal validity of user entry, termination of scene, final zip code value.
final class ZipEntryProcessor: NSObject {
    static let zipCodeDidChange = Notification.Name("zipCodeDidChange")

    let coordinator : ZipEntryCoordinator
    
    // signals
    @Published var validZip = false // for interface
    let finished = PassthroughSubject<Bool,Never>() // for coordinator
        
    var storage = Set<AnyCancellable>()
    
    init(coordinator: ZipEntryCoordinator, viewController vc:ZipEntryViewController) {
        // retain coordinator just so it doesn't go out of existence
        self.coordinator = coordinator
        super.init()
        // coordinator will listn to us
        self.coordinator.preparePipeline(self)
        // we listen to view controller for events describing what interface did
        vc.interfaceEvent
            .sink {[unowned self] in self.interpretInterfaceEvent($0)}
            .store(in: &self.storage)
    }
    
    private func interpretInterfaceEvent(_ event:ZipEntryViewController.ZipEntryInterfaceEvent) {
        switch event {
        case .userCancelled:
            self.finished.send(true)
        case .userChangedZip(let zip):
            self.validZip = self.isValid(zip)
        case .userSubmittedZip(let zip):
            self.announceNewZipCode(zip)
            self.finished.send(true)
        }
    }
    
    private func isValid(_ zip:String) -> Bool {
        guard zip.count == 5 else { return false }
        guard zip.allSatisfy(\.isDigit) else { return false }
        return true
    }
    
    // we have a zip code! tell the world
    private func announceNewZipCode(_ zip:String) {
        NotificationCenter.default.post(
            name: Self.zipCodeDidChange,
            object: self,
            userInfo: ["zip":zip]
        )
    }
    
    deinit { print("farewell", self) }

    
}
