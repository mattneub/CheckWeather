

import UIKit
import Combine

extension UIControl {
    func publisher() -> ControlPublisher {
        ControlPublisher(control:self)
    }
}

struct ControlPublisher : Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    unowned let control : UIControl
    init(control:UIControl) { self.control = control }
    func receive<S>(subscriber: S) where S : Subscriber, S.Input == Output, S.Failure == Failure {
        subscriber.receive(subscription: Inner(downstream: subscriber, sender: control))
    }
    class Inner <S:Subscriber>: NSObject, Subscription where S.Input == Output, S.Failure == Failure {
        weak var sender : UIControl?
        var downstream : S?
        init(downstream: S, sender : UIControl) {
            self.downstream = downstream
            self.sender = sender
            super.init()
        }
        func request(_ demand: Subscribers.Demand) {
            self.sender?.addTarget(self, action: #selector(doAction), for: .primaryActionTriggered)
        }
        @objc func doAction(_ sender:UIControl) {
            guard let sender = self.sender else {return}
            _ = self.downstream?.receive(sender)
        }
        private func finish() {
            self.sender?.removeTarget( self, action: #selector(doAction), for: .primaryActionTriggered)
            self.sender = nil
            self.downstream = nil
        }
        func cancel() {
            self.finish()
        }
        deinit {
            self.finish()
        }
    }
}

