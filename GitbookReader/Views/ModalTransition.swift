//
//  ModalTransition.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class ModalTransition: NSObject {
    var duration: TimeInterval = 0.4
    var isPresenting: Bool = true
    var transitionContext: UIViewControllerContextTransitioning?
}

extension ModalTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        
        return self
    }
}

extension ModalTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        self.transitionContext = transitionContext
        
        if isPresenting {
            guard let view = toViewController.view, let modal = (toViewController as? Modal)?.container else {
                transitionContext.completeTransition(true)
                return
            }
            
            view.backgroundColor = .clear
            
            containerView.addSubview(view)
            
            view.frame = containerView.bounds
            view.layoutIfNeeded()
            
            modal.center.y = modal.center.y - 50
            
            let fadeInAnimation = CAKeyframeAnimation(keyPath: "opacity")
            fadeInAnimation.values = [ 0, 1 ]
            fadeInAnimation.keyTimes = [ 0, 1 ]
            fadeInAnimation.duration = duration * 0.8
            
            modal.layer.add(fadeInAnimation, forKey: fadeInAnimation.keyPath)
            
            UIView.animate(
                withDuration: duration,
                animations: {
                    modal.center.y = modal.center.y + 50
                    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                },
                completion: { (finished) in
                    if finished {
                        transitionContext.completeTransition(true)
                    }
                }
            )
        } else {
            guard let view = fromViewController.view, let modal = (fromViewController as? Modal)?.container else {
                transitionContext.completeTransition(true)
                return
            }
            
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            
            let fadeInAnimation = CAKeyframeAnimation(keyPath: "opacity")
            fadeInAnimation.values = [ 1, 0 ]
            fadeInAnimation.keyTimes = [ 0, 1 ]
            fadeInAnimation.duration = duration * 1.2
            
            modal.layer.add(fadeInAnimation, forKey: fadeInAnimation.keyPath)
            
            UIView.animate(
                withDuration: duration,
                animations: {
                    modal.center.y = modal.center.y - 50
                    view.backgroundColor = .clear
                },
                completion: { (finished) in
                    if finished {
                        view.removeFromSuperview()
                        transitionContext.completeTransition(true)
                    }
                }
            )
        }
    }
}
