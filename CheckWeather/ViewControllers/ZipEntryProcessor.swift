

import UIKit
import Combine

// processor is the business logic
// listen for signals from interface (some are direct, some come from view controller)
// emit signals for validity of user entry, termination of scene, final zip code value

class ZipEntryProcessor: NSObject {
    
    let coordinator : ZipEntryCoordinator
    
    init(coordinator: ZipEntryCoordinator) {
        self.coordinator = coordinator
        super.init()
        self.coordinator.preparePipeline(self)
    }
    
    @Published var validZip = false
    let finished = PassthroughSubject<Bool,Never>()
        
    var pipelineStorage = Set<AnyCancellable>()
    
    func preparePipeline(fromTextField tf:ZipEntryTextField, viewController vc:ZipEntryViewController) {
        tf.$hasFiveDigits
            .sink {[unowned self] in self.validZip = $0}
            .store(in: &self.pipelineStorage)
        tf.userHitReturn
            .sink {[unowned self] in self.gotNewZipCode($0)}
            .store(in: &self.pipelineStorage)
        vc.userCancelled
            .sink {[unowned self] _ in self.finished.send(true)}
            .store(in: &self.pipelineStorage)
        vc.proposedZipCode
            .sink {[unowned self] in self.gotNewZipCode($0)}
            .store(in: &self.pipelineStorage)
    }
    
    private func gotNewZipCode(_ zip:String) {
        self.announceNewZipCode(zip)
        self.finished.send(true)
    }
    
    static let zipCodeDidChange = Notification.Name("zipCodeDidChange")
    private func announceNewZipCode(_ zip:String) {
        NotificationCenter.default.post(
            name: Self.zipCodeDidChange,
            object: self,
            userInfo: ["zip":zip]
        )
    }
    
    deinit { print("farewell", self) }

    
}
