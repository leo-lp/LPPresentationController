//
//  LPPresentationController.swift
//  LPPresentationController <https://github.com/leo-lp/LPPresentationController>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

public final class LPPresentationController: UIPresentationController {
    private let location: LPPresentationLocation
    private let dimmingView: UIView
    
    deinit {
        #if DEBUG
        print("LPPresentationController :-> release memory.")
        #endif
    }
    
    public init(presentedViewController: UIViewController,
                presenting presentingViewController: UIViewController?,
                manager: LPPresentationManager) {
        location = manager.location
        dimmingView = UIView(frame: .zero)
        dimmingView.backgroundColor = manager.dimmingColor
        dimmingView.alpha = 0.0
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        
        if manager.isEnableTapGestureForDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            dimmingView.addGestureRecognizer(tap)
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let parentBounds = containerView.bounds
        var frame = presentedViewController.view.bounds
        switch location {
        case .center(let point):
            let tf = presentedViewController.view.transform
            if let point = point {
                frame.origin = CGPoint(x: point.x, y: point.y + tf.ty)
                frame.size = CGSize(width: parentBounds.width - point.x * 2,
                                    height: parentBounds.height - point.y * 2)
            } else {
                frame.origin = CGPoint(x: (parentBounds.width - frame.width) / 2.0,
                                       y: (parentBounds.height - frame.height) / 2.0 + tf.ty)
            }
        case .bottom:
            frame.size.width = parentBounds.width
            frame.origin = CGPoint(x: 0.0, y: parentBounds.height - frame.height)
        case .left:
            frame.size.height = parentBounds.height
            frame.origin = .zero
        case .right:
            frame.size.height = parentBounds.height
            frame.origin = CGPoint(x: parentBounds.width - frame.width, y: 0.0)
        case .top:
            frame.size.width = parentBounds.width
            frame.origin = .zero
        }
        return frame
    }
    
    public override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            return dimmingView.alpha = 1.0
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            return dimmingView.alpha = 0.0
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    @objc private func tapHandler(_ recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
