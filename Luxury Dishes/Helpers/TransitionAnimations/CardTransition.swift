//
//  CardTransition.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/27/23.
//

import UIKit

final class CardTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: CustomCell
    }

    let params: Params
    
    init(params: Params) {
        self.params = params
        super.init()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = PresentCardAnimator.Params.init(
            fromCardFrame: self.params.fromCardFrame,
            fromCell: self.params.fromCell)
        return PresentCardAnimator(params: params)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = DismissCardAnimator.Params.init(fromCardFrame: self.params.fromCardFrame, fromCardFrameWithoutTransform: self.params.fromCardFrameWithoutTransform, fromCell: self.params.fromCell)
        return DismissCardAnimator(params: params)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    // IMPORTANT: Must set modalPresentationStyle to `.custom` for this to be used.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
