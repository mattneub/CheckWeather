

import UIKit
import Combine

extension UIControl {
    func publisher(for event: UIControl.Event = .primaryActionTriggered) -> ControlPublisher {
        ControlPublisher(control:self, for:event)
    }
}

struct ControlPublisher : Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    unowned let control : UIControl
    let event : UIControl.Event
    init(control:UIControl, for event:UIControl.Event) {
        self.control = control
        self.event = event
    }
    func receive<S>(subscriber: S) where S : Subscriber, S.Input == Output, S.Failure == Failure {
        subscriber.receive(subscription: Inner(downstream: subscriber, sender: control, event: event))
    }
    class Inner <S:Subscriber>: NSObject, Subscription where S.Input == Output, S.Failure == Failure {
        weak var sender : UIControl?
        let event : UIControl.Event
        var downstream : S?
        init(downstream: S, sender : UIControl, event : UIControl.Event) {
            self.downstream = downstream
            self.sender = sender
            self.event = event
            super.init()
        }
        func request(_ demand: Subscribers.Demand) {
            self.sender?.addTarget(self, action: #selector(doAction), for: event)
        }
        @objc func doAction(_ sender:UIControl) {
            guard let sender = self.sender else {return}
            _ = self.downstream?.receive(sender)
        }
        private func finish() {
            self.sender?.removeTarget(self, action: #selector(doAction), for: event)
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
