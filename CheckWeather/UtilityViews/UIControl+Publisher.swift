

import UIKit
import Combine

protocol ControlWithPublisher : UIControl {}
extension UIControl : ControlWithPublisher {}
extension ControlWithPublisher {
    func publisher(for event: UIControl.Event = .primaryActionTriggered) -> ControlPublisher<Self> {
        ControlPublisher(control:self, for:event)
    }
}

struct ControlPublisher<T:UIControl> : Publisher {
    typealias Output = T
    typealias Failure = Never
    unowned let control : T
    let event : UIControl.Event
    init(control:T, for event:UIControl.Event) {
        self.control = control
        self.event = event
    }
    func receive<S>(subscriber: S) where S : Subscriber, S.Input == Output, S.Failure == Failure {
        subscriber.receive(subscription: Inner(downstream: subscriber, sender: control, event: event))
    }
    class Inner <S:Subscriber>: NSObject, Subscription where S.Input == Output, S.Failure == Failure {
        weak var sender : T?
        let event : UIControl.Event
        var downstream : S?
        init(downstream: S, sender : T, event : UIControl.Event) {
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

