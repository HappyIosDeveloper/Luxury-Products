//
//  Extensions.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

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

extension UIView {
    
    func rotate() {
        transform = .identity
        UIView.animate(withDuration: 1.5, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        })
    }
    
    func dropShadow() {
        if layer.shadowPath == nil {
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: bounds.width / 3, height: bounds.width / 3)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = bounds.width / 2
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
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
