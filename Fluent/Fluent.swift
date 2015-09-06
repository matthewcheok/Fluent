//
//  Fluent.swift
//  Fluent
//
//  Created by Matthew Cheok on 4/9/15.
//  Copyright © 2015 Matthew Cheok. All rights reserved.
//

import UIKit

public class Fluent {
    public typealias AnimationBlock = () -> Void

    private var animations: [AnimationBlock] = []
    private let duration: NSTimeInterval
    private let velocity: CGFloat
    private let damping: CGFloat
    private let options: UIViewAnimationOptions
    private var next: Fluent?
    
    init(duration: NSTimeInterval, velocity: CGFloat, damping: CGFloat, options: UIViewAnimationOptions) {
        self.duration = duration
        self.velocity = velocity
        self.damping = damping
        self.options = options
    }
    
    func performAdditionalAnimations() {
    }
    
    deinit {
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: options, animations: {
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

public class ViewFluent: Fluent {
    private let view: UIView
    
    enum AffineTransformType {
        case None
        case Absolute
        case Relative
    }
    private var transformType: AffineTransformType = .None
    private var transformMatrix = CGAffineTransformIdentity
    private let transformError = "You cannot mix absolute and relative transforms"
    
    init(view: UIView, duration: NSTimeInterval, velocity: CGFloat, damping: CGFloat, options: UIViewAnimationOptions) {
        self.view = view
        super.init(duration: duration, velocity: velocity, damping: damping, options: options)
    }
    
    public func scale(factor: CGFloat) -> Self {
        precondition(transformType != .Relative, transformError)
        transformType = .Absolute
        transformMatrix = CGAffineTransformScale(transformMatrix, factor, factor)
        return self
    }
    
    public func translate(x: CGFloat, _ y: CGFloat) -> Self {
        precondition(transformType != .Relative, transformError)
        transformType = .Absolute
        transformMatrix = CGAffineTransformTranslate(transformMatrix, x, y)
        return self
    }
    
    public func rotate(cycles: CGFloat) -> Self {
        precondition(transformType != .Relative, transformError)
        transformType = .Absolute
        transformMatrix = CGAffineTransformRotate(transformMatrix, cycles * 2 * CGFloat(M_PI_2))
        return self
    }
    
    public func scaleBy(factor: CGFloat) -> Self {
        precondition(transformType != .Absolute, transformError)
        transformType = .Relative
        transformMatrix = CGAffineTransformScale(transformMatrix, factor, factor)
        return self
    }
    
    public func translateBy(x: CGFloat, _ y: CGFloat) -> Self {
        precondition(transformType != .Absolute, transformError)
        transformType = .Relative
        transformMatrix = CGAffineTransformTranslate(transformMatrix, x, y)
        return self
    }
    
    public func rotateBy(cycles: CGFloat) -> Self {
        precondition(transformType != .Absolute, transformError)
        transformType = .Relative
        transformMatrix = CGAffineTransformRotate(transformMatrix, cycles * 2 * CGFloat(M_PI_2))
        return self
    }
    
    override func performAdditionalAnimations() {
        if transformType == .Absolute {
            view.transform = transformMatrix
        }
        else if transformType == .Relative {
            view.transform = CGAffineTransformConcat(view.transform, transformMatrix)
        }
    }
    
    public func backgroundColor(color: UIColor) -> Self {
        animations.append({
            [view] in
            view.backgroundColor = color
        })
        return self
    }
    
    public func alpha(alpha: CGFloat) -> Self {
        animations.append({
            [view] in
            view.alpha = alpha
            })
        return self
    }
    
    public func frame(frame: CGRect) -> Self {
        animations.append({
            [view] in
            view.frame = frame
            })
        return self
    }
    
    public func bounds(bounds: CGRect) -> Self {
        animations.append({
            [view] in
            view.bounds = bounds
            })
        return self
    }
    
    public func center(center: CGPoint) -> Self {
        animations.append({
            [view] in
            view.center = center
            })
        return self
    }
    
    public func custom(animation: AnimationBlock) -> Self {
        animations.append(animation)
        return self
    }
    
    public func waitThenAnimate(duration: NSTimeInterval, velocity: CGFloat = 0, damping: CGFloat = 1, options: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState]) -> ViewFluent {
        precondition(next == nil, "You have already specified a completion handler")
        let after = ViewFluent(view: view, duration: duration, velocity: velocity, damping: damping, options: options)
        next = after
        return after
    }
}

public extension UIView {
    public func animate(duration: NSTimeInterval, velocity: CGFloat = 0, damping: CGFloat = 1, options: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState]) -> ViewFluent {
        return ViewFluent(view: self, duration: duration, velocity: velocity, damping: damping, options: options)
    }
}
