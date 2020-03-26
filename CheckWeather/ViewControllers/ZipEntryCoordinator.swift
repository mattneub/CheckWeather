

import UIKit
import Combine

/// Coordinator for zip entry, just navigates: listen to processor and dismiss v.c. when it declares termination
class ZipEntryCoordinator: NSObject {
    
    unowned let vc : UIViewController
    init(viewController:UIViewController) {
        self.vc = viewController
    }
    
    var pipelineStorage = Set<AnyCancellable>()
    
    func preparePipeline(_ processor:ZipEntryProcessor) {
        processor.finished
            .filter {$0}
            .sink { [unowned self] _ in self.vc.dismiss(animated:true) }
            .store(in: &self.pipelineStorage)
    }
    
    deinit { print("farewell", self) }
            
}
