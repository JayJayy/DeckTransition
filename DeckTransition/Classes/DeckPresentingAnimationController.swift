//
//  DeckPresentingAnimationController.swift
//  DeckTransition
//
//  Created by Harshil Shah on 15/10/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit

final class DeckPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	
	// MARK:- Private variables
	
	private let duration: TimeInterval?
	private let animation: (() -> ())?
	private let completion: ((Bool) -> ())?
	private let cornerRadius: CGFloat
	
	// MARK:- Initializers
	
	init(cornerRadius: CGFloat, duration: TimeInterval?, animation: (() -> ())?, completion: ((Bool) -> ())?) {
		self.duration = duration
		self.animation = animation
		self.completion = completion
		self.cornerRadius = cornerRadius
	}
	
	// MARK:- UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentingViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let presentedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView = transitionContext.containerView
        
        let offScreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        
        containerView.addSubview(presentedViewController.view)
        presentedViewController.view.frame = offScreenFrame
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                let scale: CGFloat = 1 - (40/presentingViewController.view.frame.height)
				let cornerRadius = self?.cornerRadius ?? 8.0
				
                presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
                presentingViewController.view.alpha = 0.8
				presentingViewController.view.layer.cornerRadius = cornerRadius
				presentingViewController.view.layer.masksToBounds = true
				
                presentedViewController.view.frame = transitionContext.finalFrame(for: presentedViewController)
				
				if cornerRadius > 0.0 {
					presentedViewController.view.round(corners: [.topLeft, .topRight], withRadius: cornerRadius)
				}
				
				self?.animation?()
            }, completion: { [weak self] finished in
                transitionContext.completeTransition(finished)
				self?.completion?(finished)
            }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration ?? 0.3
    }
    
}
