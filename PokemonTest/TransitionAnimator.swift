//
//  TransitionAnimator.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    var duration: TimeInterval!
    var transitionContext: UIViewControllerContextTransitioning?
    var isPush = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)!
        let buttonCenter = isPush ? ((fromViewController as! UINavigationController).topViewController as! HomeViewController).playButton.center : (fromViewController as! PlayViewController).buttonCenter
        if isPush {
            containerView.addSubview(toViewController.view)
        } else {
            containerView.addSubview(fromViewController!.view)
        }
        
        
        let triangleMaskIntial = isPush ? pathTriangle(center: buttonCenter!, length: 5.0) : pathTriangle(center: buttonCenter!, length: 5.0*toViewController.view.frame.height)
        let triangleMaskFinal = isPush ? pathTriangle(center: buttonCenter!, length: 5.0*toViewController.view.frame.height) : pathTriangle(center: buttonCenter!, length: 5.0)
        let maskLayer = CAShapeLayer()
        maskLayer.path = triangleMaskFinal.cgPath
        //        toViewController.view.layer.mask = maskLayer
        if isPush {
            toViewController.view.layer.mask = maskLayer
        } else {
            fromViewController?.view.layer.mask = maskLayer
        }
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = triangleMaskIntial.cgPath
        maskLayerAnimation.toValue = triangleMaskFinal.cgPath
        maskLayerAnimation.duration = duration
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
        if isPush {
            self.transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        } else {
            self.transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        }
        
    }
    
    private func pathTriangle(center: CGPoint, length: CGFloat) -> UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: center.x + length / CGFloat(sqrt(3.0)), y: center.y))
        trianglePath.addLine(to: CGPoint(x: center.x - length / CGFloat(2.0*sqrt(3.0)), y: center.y - length / 2.0))
        trianglePath.addLine(to: CGPoint(x: center.x - length / CGFloat(2.0*sqrt(3.0)), y: center.y + length / 2.0))
        trianglePath.close()
        return trianglePath
    }
}
