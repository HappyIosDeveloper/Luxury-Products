//
//  Extensions.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

extension UIView {
    
    func parentAppearEffect(isScrollingUp: Bool) {
        var new = CATransform3DIdentity
        new.m34 = isScrollingUp ? (-1.0 / 500.0) : (1.0 / 500.0)
        new = CATransform3DRotate(new, 60 * .pi / 180, 1, 0, 0)
        self.transform3D = new
        var old = CATransform3DIdentity
        old.m34 = 0
        old = CATransform3DRotate(old, 0, 0, 0, 0)
        UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.transform3D = old
        }
    }
}
