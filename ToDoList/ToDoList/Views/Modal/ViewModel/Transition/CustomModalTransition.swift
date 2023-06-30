import UIKit

class CustomModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0.5
            
            toViewController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        }, completion: { _ in
            fromViewController.view.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
