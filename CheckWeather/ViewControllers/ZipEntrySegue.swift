
import UIKit

// custom transition animation
// nicely encapsulated into the _segue_

final class ZipEntrySegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destination
        dest.modalPresentationStyle = .custom
        dest.transitioningDelegate = self
        super.perform()
    }
}
extension ZipEntrySegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ZipEntryPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension ZipEntrySegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!
        
        let con = ctx.containerView
        
        let r1start = ctx.initialFrame(for:vc1)
        let r2end = ctx.finalFrame(for:vc2)
        
        if let v2 = ctx.view(forKey:.to) { // presentation
            var r2start = r2end
            r2start.origin.y -= r2start.size.height
            v2.frame = r2start
            con.addSubview(v2)
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, animations: {
                v2.frame = r2end
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
            })
        } else if let v1 = ctx.view(forKey:.from) { // dismissal
            var r1end = r1start
            r1end.origin.y = -r1end.size.height
            UIView.animate(withDuration:0.4, animations: {
                v1.frame = r1end
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
            })
        }
    }

}

fileprivate final class ZipEntryPresentationController : UIPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        shadow.alpha = 0
        con.insertSubview(shadow, at: 0)
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 1
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v?.tintAdjustmentMode = .dimmed
            })
    }
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 0
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v?.tintAdjustmentMode = .automatic
            })
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        let v = self.presentedView!
        let con = self.containerView!
        v.center = CGPoint(x:con.bounds.width/2, y:150)
        return v.frame.integral
    }
    
    override func containerViewWillLayoutSubviews() {
        let v = self.presentedView!
        v.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin]
    }
    
}

