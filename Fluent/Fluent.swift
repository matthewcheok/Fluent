//
//  Fluent.swift
//  Fluent
//
//  Created by Matthew Cheok on 4/9/15.
//  Copyright © 2015 Matthew Cheok. All rights reserved.
//

import UIKit

open class Fluent {
    public typealias AnimationBlock = () -> Void

    fileprivate var animations: [AnimationBlock] = []
    fileprivate let duration: TimeInterval
    fileprivate let velocity: CGFloat
    fileprivate let damping: CGFloat
    fileprivate let options: UIViewAnimationOptions
    fileprivate var next: Fluent?
    
    init(duration: TimeInterval, velocity: CGFloat, damping: CGFloat, options: UIViewAnimationOptions) {
        self.duration = duration
        self.velocity = velocity
        self.damping = damping
        self.options = options
    }
    
    func performAdditionalAnimations() {
    }
    
    deinit {
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: options, animations: {
            [animations, performAdditionalAnimations] in
            for animation in animations {
                animation()
            }
            performAdditionalAnimations()
            }, completion: {
                [next] (finished) in
                next
            })
    }
}

open class ViewFluent: Fluent {
    fileprivate let view: UIView
    
    enum AffineTransformType {
        case none
        case absolute
        case relative
    }
    fileprivate var transformType: AffineTransformType = .none
    fileprivate var transformMatrix = CGAffineTransform.identity
    fileprivate let transformError = "You cannot mix absolute and relative transforms"
    
    init(view: UIView, duration: TimeInterval, velocity: CGFloat, damping: CGFloat, options: UIViewAnimationOptions) {
        self.view = view
        super.init(duration: duration, velocity: velocity, damping: damping, options: options)
    }
    
    open func scale(_ factor: CGFloat) -> Self {
        precondition(transformType != .relative, transformError)
        transformType = .absolute
        transformMatrix = transformMatrix.scaledBy(x: factor, y: factor)
        return self
    }
    
    open func translate(_ x: CGFloat, _ y: CGFloat) -> Self {
        precondition(transformType != .relative, transformError)
        transformType = .absolute
        transformMatrix = transformMatrix.translatedBy(x: x, y: y)
        return self
    }
    
    open func rotate(_ cycles: CGFloat) -> Self {
        precondition(transformType != .relative, transformError)
        transformType = .absolute
        transformMatrix = transformMatrix.rotated(by: cycles * 2 * CGFloat(M_PI_2))
        return self
    }
    
    open func scaleBy(_ factor: CGFloat) -> Self {
        precondition(transformType != .absolute, transformError)
        transformType = .relative
        transformMatrix = transformMatrix.scaledBy(x: factor, y: factor)
        return self
    }
    
    open func translateBy(_ x: CGFloat, _ y: CGFloat) -> Self {
        precondition(transformType != .absolute, transformError)
        transformType = .relative
        transformMatrix = transformMatrix.translatedBy(x: x, y: y)
        return self
    }
    
    open func rotateBy(_ cycles: CGFloat) -> Self {
        precondition(transformType != .absolute, transformError)
        transformType = .relative
        transformMatrix = transformMatrix.rotated(by: cycles * 2 * CGFloat(M_PI_2))
        return self
    }
    
    override func performAdditionalAnimations() {
        if transformType == .absolute {
            view.transform = transformMatrix
        }
        else if transformType == .relative {
            view.transform = view.transform.concatenating(transformMatrix)
        }
    }
    
    open func backgroundColor(_ color: UIColor) -> Self {
        animations.append({
            [view] in
            view.backgroundColor = color
        })
        return self
    }
    
    open func alpha(_ alpha: CGFloat) -> Self {
        animations.append({
            [view] in
            view.alpha = alpha
            })
        return self
    }
    
    open func frame(_ frame: CGRect) -> Self {
        animations.append({
            [view] in
            view.frame = frame
            })
        return self
    }
    
    open func bounds(_ bounds: CGRect) -> Self {
        animations.append({
            [view] in
            view.bounds = bounds
            })
        return self
    }
    
    open func center(_ center: CGPoint) -> Self {
        animations.append({
            [view] in
            view.center = center
            })
        return self
    }
    
    open func custom(_ animation: @escaping AnimationBlock) -> Self {
        animations.append(animation)
        return self
    }
    
    open func waitThenAnimate(_ duration: TimeInterval, velocity: CGFloat = 0, damping: CGFloat = 1, options: UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState]) -> ViewFluent {
        precondition(next == nil, "You have already specified a completion handler")
        let after = ViewFluent(view: view, duration: duration, velocity: velocity, damping: damping, options: options)
        next = after
        return after
    }
}

public extension UIView {
    public func animate(_ duration: TimeInterval, velocity: CGFloat = 0, damping: CGFloat = 1, options: UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState]) -> ViewFluent {
        return ViewFluent(view: self, duration: duration, velocity: velocity, damping: damping, options: options)
    }
}
