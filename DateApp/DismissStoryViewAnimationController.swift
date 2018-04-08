//
//  DismissStoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/18/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import Foundation

import UIKit

@objc class DismissStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    @objc var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let containerView = transitionContext.containerView
        /*
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? ProfileViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? SwipeViewController else {
                return
        } */
        
        let fromViewController = transitionContext.viewController(forKey: .from) as? ProfileViewController
   //     let toViewController = transitionContext.viewController(forKey: .to) as? RootViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        // 2
    //    toViewController?.view.isHidden = true
     //   containerView.addSubview((toViewController?.view)!)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController?.positionContainer(20.0,
                                                 right: 20.0,
                                                 top: self.selectedCardFrame.origin.y + 80,
                                                 bottom: 0.0)
            fromViewController?.setHeaderHeight(self.selectedCardFrame.size.height)
            fromViewController?.configureRoundedCorners(true)
        }) { (_) in
            toViewController?.view.isHidden = false
            fromViewController?.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
}
