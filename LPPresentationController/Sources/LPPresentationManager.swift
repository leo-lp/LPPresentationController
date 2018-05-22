//
//  LPPresentationManager.swift
//  LPPresentationController <https://github.com/leo-lp/LPPresentationController>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

// MARK: -
// MARK: - UIViewController Extension

private var LPPresentationManagerKey: Void?
extension UIViewController {
    
    /// 为UIViewController扩展lp_presentationManager属性
    public var lp_presentationManager: LPPresentationManager? {
        get {
            let objc = objc_getAssociatedObject(self, &LPPresentationManagerKey)
            return objc as? LPPresentationManager
        }
        set {
            objc_setAssociatedObject(self,
                                     &LPPresentationManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            transitioningDelegate = newValue
        }
    }
    
    /// 用LPPresentationController的方式显示一个弹窗
    /// 注：用lp_present弹出的视图控制器可用系统自带的“dismiss(animated:,completion:)”方法隐藏
    ///
    /// - Parameters:
    ///   - controller: 将要显示的viewController
    ///   - manager: Presentation配置管理
    ///   - completion: 显示完成回调
    public func lp_present(_ controller: UIViewController,
                           manager: LPPresentationManager,
                           completion: (() -> Swift.Void)?) {
        controller.lp_presentationManager = manager
        controller.modalPresentationStyle = .custom
        present(controller, animated: true, completion: completion)
    }
}

// MARK: -
// MARK: - LPPresentationManager Class

public class LPPresentationManager: NSObject {
    /// 视图在屏幕上停留位置；默认.center(nil)，nil代表不设置view与屏幕边缘的距离
    public var location: LPPresentationLocation
    
    /// 触摸view边缘区域是否消失；默认true
    public var isEnableTapGestureForDismiss: Bool
    
    /// 该属性可设置view边缘区域的背景颜色，默认UIColor(white: 0.0, alpha: 0.3)
    public var dimmingColor: UIColor
    
    public init(_ location: LPPresentationLocation = .center(nil),
                dismissOfTap: Bool = true,
                dimmingColor: UIColor = UIColor(white: 0.0, alpha: 0.3)) {
        self.location = location
        self.isEnableTapGestureForDismiss = dismissOfTap
        self.dimmingColor = dimmingColor
        super.init()
    }
    
    deinit {
        #if DEBUG
        print("LPPresentationManager :-> release memory.")
        #endif
    }
}

extension LPPresentationManager: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        return LPPresentationController(presentedViewController: presented,
                                        presenting: presenting,
                                        manager: self)
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LPCurveLinearAnimator(location: location)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LPCurveLinearAnimator(location: location)
    }
}
