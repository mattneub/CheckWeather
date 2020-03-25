

import UIKit
import Combine

// coordinator navigates
// listen to processor and dismiss v.c. when it declares termination

class ZipEntryCoordinator: NSObject {
    
    unowned let vc : ZipEntryViewController
    init(viewController:ZipEntryViewController) {
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
