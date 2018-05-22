//
//  LPPresentationModel.swift
//  LPPresentationController <https://github.com/leo-lp/LPPresentationController>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

public enum LPPresentationLocation {
    public typealias LPEdgeSpacing = CGPoint // 边缘距离
    case left
    case right
    case top
    case bottom
    case center(LPEdgeSpacing?) // 居中显示时可设置边缘距离，如果为nil则默认使用view.frame.size
}

public struct LPPresentationAnimatorContext {
    public let transitionContext: UIViewControllerContextTransitioning
    public let isPresenting: Bool
    public let containerView: UIView
    
    public let fromVC: UIViewController?
    public let toVC: UIViewController?
    public let animatingVC: UIViewController
    
    public var initialFrame: CGRect {
        return transitionContext.initialFrame(for: animatingVC)
    }
    
    public var finalFrame: CGRect {
        return transitionContext.finalFrame(for: animatingVC)
    }
}
