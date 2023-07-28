//
//  Extensions.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

// MARK: - Cell Parent Animations
extension UIView {
    
    func parentAppearEffect(isScrollingUp: Bool) {
        transform3D = getFlippedTransition(isScrollingUp: isScrollingUp)
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.transform3D = self.getDefaultTransition(isScrollingUp: isScrollingUp)
        }
    }
    
    private func getFlippedTransition(isScrollingUp: Bool)-> CATransform3D {
        alpha = 0.5
        var new = CATransform3DIdentity
        new.m34 = isScrollingUp ? (-1.0 / 900.0) : (1.0 / 500.0)
        new = CATransform3DRotate(new, 90 * .pi / 180, 1, 0, 90 * .pi / 180)
        return new
    }
    
    private func getDefaultTransition(isScrollingUp: Bool)-> CATransform3D {
        alpha = 1
        var old = CATransform3DIdentity
        old.m34 = 0
        old = CATransform3DRotate(old, 0, 0, 0, 0)
        return old
    }
}

// MARK: - Cell Child Animations
extension UIView {
    
    func dishAppearEffect() {
        transform3D = getFlippedTransition()
        layer.position.x = UIScreen.main.bounds.width
        UIView.animate(withDuration: 2, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction) { [self] in
            transform3D = getDefaultTransition()
            layer.position.x = superview!.center.x - CustomCell.margin
        }
    }

    private func getFlippedTransition()-> CATransform3D {
        var new = CATransform3DIdentity
        new.m34 = -0.001
        new = CATransform3DRotate(new, .pi / 2, 0, .pi, 0)
        return new
    }

    private func getDefaultTransition()-> CATransform3D {
        var old = CATransform3DIdentity
        old.m34 = 0
        old = CATransform3DRotate(old, 0, 0, 0, 0)
        return old
    }
}

// MARK: - Rotations
extension UIView {
    
    func textRotateTop(delay: Double = 1) {
        alpha = 0
        transform = CGAffineTransform(rotationAngle: -.pi).translatedBy(x: 0.1, y: 0.1)
        UIView.animate(withDuration: 1, delay: delay, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func textRotateBottom(delay: Double = 1.2) {
        alpha = 0
        transform = .identity
        UIView.animate(withDuration: 1, delay: delay, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(rotationAngle: .pi).translatedBy(x: 0.1, y: 0.1)
        })
    }
    
    func rotate() {
        transform = .identity
        UIView.animate(withDuration: 1.5, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        })
    }
    
    func infiniteRotation(startAngle: Double = .pi) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: startAngle * 2)
        rotation.duration = 20
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func orderButtonAppearAnimation() {
        alpha = 0
        let tempY = layer.position.y
        layer.position.y += 200
        UIView.animate(withDuration: 3, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction) { [self] in
            alpha = 1
            layer.position.y = tempY
            transform3D = getFlippedTransition(isScrollingUp: false)
        }
        UIView.animate(withDuration: 3, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .beginFromCurrentState]) { [self] in
            transform3D = getDefaultTransition(isScrollingUp: true)
        } completion: { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction) { [self] in
                    transform = CGAffineTransform(scaleX: -1, y: 1)
                } completion: { isFinished in
                    if isFinished {
                        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction) { [self] in
                            transform = CGAffineTransform(scaleX: 1, y: 1)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Shadows & Corners
extension UIView {
    
    func dropShadowAndCornerRadius(_ value: Double, opacity:Float = 0.1) {
        roundUp(value)
        dropShadow(opacity: opacity, corner: value)
    }

    func dropShadow(opacity:Float = 0.05, corner: Double) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = corner
    }
    
    func roundUp(_ value: Double) {
        layer.cornerRadius = value
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
    }
    
    func dropShadow(isForceShrink: Bool = false) {
        let margin = bounds.width / 5
        if layer.shadowPath == nil {
            layer.masksToBounds = false
            layer.shadowOffset = isForceShrink ? .zero : CGSize(width: bounds.width / 3, height: bounds.width / 3)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = bounds.width / 2
            layer.shadowPath = isForceShrink ? UIBezierPath(rect: bounds.inset(by: .init(top: margin, left: margin, bottom: margin, right: margin))).cgPath : UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    func dropMiniShadow() {
        if layer.shadowPath == nil {
            layer.masksToBounds = false
            layer.shadowOffset = .zero
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowRadius = bounds.width / 8
            layer.shadowPath = UIBezierPath(rect: bounds.offsetBy(dx: 0.3, dy: 0.3)).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
}

// MARK: - Pops
extension UIView {
    
    func popIn(comple: (()->())? = nil) {
        let defaultTransform = transform
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        alpha = 0.0
        isHidden = false
        layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.transform = defaultTransform
            self.alpha = 1
            self.layoutIfNeeded()
        } completion: { finished in
            if finished {
                comple?()
            }
        }
    }
    
    func popOut(duration: Double = 0.5, comple: (()->())? = nil) {
        let defaultTransform = transform
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction) {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
            self.layoutIfNeeded()
        } completion: { finished in
            if finished {
                self.isHidden = true
                self.transform = defaultTransform
                self.alpha = 1
                self.layoutIfNeeded()
                comple?()
            }
        }
    }
    
    func pop(duration: CGFloat = 0.6, startingAlpha: Double = 1) {
        isHidden = false
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        alpha = startingAlpha
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: duration + 0.2, initialSpringVelocity: 5.0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut], animations: { () -> Void in
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.layoutIfNeeded()
        }) { (Bool) -> Void in
            self.layoutIfNeeded()
        }
    }
}

// MARK: Parallax Effect
extension UIView {
    
    func addParallax(range: Double = 50) {
        if motionEffects.isEmpty {
            let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            horizontalMotionEffect.minimumRelativeValue = -range
            horizontalMotionEffect.maximumRelativeValue = range
            let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            verticalMotionEffect.minimumRelativeValue = -range
            verticalMotionEffect.maximumRelativeValue = range
            let motionEffectGroup = UIMotionEffectGroup()
            motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
            addMotionEffect(motionEffectGroup)
        }
    }
}

// MARK: - Dish Detail Controller
extension UIView {
    
    func platConfetti() {
        let confettiView = SwiftConfettiView(frame: self.bounds)
        confettiView.type = .confetti
        addSubview(confettiView)
        confettiView.setup()
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            confettiView.stopConfetti()
        }
    }
}
