//
//  YLCurveLinearAnimator.swift
//  LPPresentationController <https://github.com/leo-lp/LPPresentationController>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

open class LPCurveLinearAnimator: LPPresentationAnimator {
    public let location: LPPresentationLocation
    
    public init(location: LPPresentationLocation) {
        self.location = location
        super.init()
    }
    
    public override func animateTransition(using ctx: LPPresentationAnimatorContext) {
        let transitionContext = ctx.transitionContext
        let isPresenting = ctx.isPresenting
        let containerView = ctx.containerView
        let animatingVC = ctx.animatingVC
        let presentedFrame = ctx.finalFrame
        
        var dismissedFrame = presentedFrame
        switch location {
        case .center:
            dismissedFrame.origin.y = containerView.frame.height
        case .bottom:
            dismissedFrame.origin.y = containerView.frame.height
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        }
        
        let initialFrame = isPresenting ? dismissedFrame : presentedFrame
        let finalFrame = isPresenting ? presentedFrame : dismissedFrame
        
        let animationDuration = super.transitionDuration(using: transitionContext)
        animatingVC.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            animatingVC.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
