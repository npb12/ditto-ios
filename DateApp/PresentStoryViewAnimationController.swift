//
//  StoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

@objc class PresentStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    @objc var selectedCardFrame: CGRect = .zero

    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from) as? RootViewController
        let toViewController = transitionContext.viewController(forKey: .to) as? ProfileViewController

        // 2
        containerView.addSubview((toViewController?.view)!)
        toViewController?.positionContainer(20.0,
                                           right: 20.0,
                                           top: selectedCardFrame.origin.y + 20.0,
                                           bottom: 0.0)
        toViewController?.setHeaderHeight(self.selectedCardFrame.size.height)
        toViewController?.configureRoundedCorners(true)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            toViewController?.positionContainer( 0.0,
                                               right: 0.0,
                                               top: 0.0,
                                               bottom: 0.0)
            toViewController?.setHeaderHeight(425)
            toViewController?.view.backgroundColor = .white
            toViewController?.configureRoundedCorners(false)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
}
