//
//  YLPresentationAnimator.swift
//  LPPresentationController <https://github.com/leo-lp/LPPresentationController>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

open class LPPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    deinit {
        #if DEBUG
        print("LPPresentationAnimator :-> release memory.")
        #endif
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let isPresenting: Bool = (toVC?.presentingViewController == fromVC)
        
        guard let animatingVC = isPresenting ? toVC : fromVC else { return }
        
        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(animatingVC.view)
        }
        
        let ctx = LPPresentationAnimatorContext(transitionContext: transitionContext,
                                                isPresenting: isPresenting,
                                                containerView: containerView,
                                                fromVC: fromVC,
                                                toVC: toVC,
                                                animatingVC: animatingVC)
        animateTransition(using: ctx)
    }
    
    public func animateTransition(using ctx: LPPresentationAnimatorContext) {
    }
}
