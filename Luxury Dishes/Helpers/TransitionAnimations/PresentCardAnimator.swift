//
//  PresentCardAnimator.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/27/23.
//

import UIKit

final class PresentCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let params: Params
    
    struct Params {
        let fromCardFrame: CGRect
        let fromCell: CustomCell
    }
    
    private let presentAnimationDuration: TimeInterval
    private let springAnimator: UIViewPropertyAnimator
    private var transitionDriver: PresentCardTransitionDriver?
    
    init(params: Params) {
        self.params = params
        self.springAnimator = PresentCardAnimator.createBaseSpringAnimator(params: params)
        self.presentAnimationDuration = springAnimator.duration
        super.init()
    }
    
    private static func createBaseSpringAnimator(params: PresentCardAnimator.Params) -> UIViewPropertyAnimator {
        // Damping between 0.7 (far away) and 1.0 (nearer)
        let cardPositionY = params.fromCardFrame.minY
        let distanceToBounce = abs(params.fromCardFrame.minY)
        let extentToBounce = cardPositionY < 0 ? params.fromCardFrame.height : UIScreen.main.bounds.height
        let dampFactorInterval: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampFactorInterval * (distanceToBounce / extentToBounce)
        
        // Duration between 0.5 (nearer) and 0.9 (nearer)
        let baselineDuration: TimeInterval = 0.5
        let maxDuration: TimeInterval = 0.9
        let duration: TimeInterval = baselineDuration + (maxDuration - baselineDuration) * TimeInterval(max(0, distanceToBounce)/UIScreen.main.bounds.height)
        
        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // 1.
        return presentAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 2.
        transitionDriver = PresentCardTransitionDriver(params: params, transitionContext: transitionContext, baseAnimator: springAnimator)
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        // 4.
        transitionDriver = nil
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // 3.
        return transitionDriver!.animator
    }
}

final class PresentCardTransitionDriver {
    
    let animator: UIViewPropertyAnimator
    
    init(params: PresentCardAnimator.Params, transitionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator) {
        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (home: ViewController, cardDetail: DishViewController) = (
            (ctx.viewController(forKey: .from) as? UINavigationController)?.viewControllers.first as! ViewController,
            ctx.viewController(forKey: .to)! as! DishViewController)
        
        let cardDetailView = ctx.view(forKey: .to)!
        let fromCardFrame = params.fromCardFrame
        
        // Temporary container view for animation
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animatedContainerView)
        
        do /* Fix centerX/width/height of animated container to container */ {
            let animatedContainerConstraints = [
                animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
                animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
                animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            ]
            NSLayoutConstraint.activate(animatedContainerConstraints)
        }
        
        let animatedContainerVerticalConstraint: NSLayoutConstraint = {
            switch GlobalConstants.cardVerticalExpandingStyle {
            case .fromCenter:
                return animatedContainerView.centerYAnchor.constraint(
                    equalTo: container.centerYAnchor,
                    constant: (fromCardFrame.height/2 + fromCardFrame.minY) - container.bounds.height/2
                )
            case .fromTop:
                return animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: fromCardFrame.minY)
            }
        }()
        animatedContainerVerticalConstraint.isActive = true
        animatedContainerView.addSubview(cardDetailView)
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        do /* Pin top (or center Y) and center X of the card, in animated container view */ {
            let verticalAnchor: NSLayoutConstraint = {
                switch GlobalConstants.cardVerticalExpandingStyle {
                case .fromCenter:
                    return cardDetailView.centerYAnchor.constraint(equalTo: animatedContainerView.centerYAnchor)
                case .fromTop:
                    // WTF: SUPER WEIRD BUG HERE.
                    // I should set this constant to 0 (or nil), to make cardDetailView sticks to the animatedContainerView's top.
                    // BUT, I can't set constant to 0, or any value in range (-1,1) here, or there will be abrupt top space inset while animating.
                    // Funny how -1 and 1 work! WTF. You can try set it to 0.
                    return cardDetailView.topAnchor.constraint(equalTo: animatedContainerView.topAnchor, constant: -1)
                }
            }()
            let cardConstraints = [
                verticalAnchor,
                cardDetailView.centerXAnchor.constraint(equalTo: animatedContainerView.centerXAnchor),
            ]
            NSLayoutConstraint.activate(cardConstraints)
        }
        let cardWidthConstraint = cardDetailView.widthAnchor.constraint(equalToConstant: fromCardFrame.width)
        let cardHeightConstraint = cardDetailView.heightAnchor.constraint(equalToConstant: fromCardFrame.height)
        NSLayoutConstraint.activate([cardWidthConstraint, cardHeightConstraint])
        
        cardDetailView.layer.cornerRadius = GlobalConstants.cardCornerRadius
        
        // -------------------------------
        // Final preparation
        // -------------------------------
        params.fromCell.isHidden = true
        params.fromCell.resetTransform()
        
        let topTemporaryFix = screens.cardDetail.view.topAnchor.constraint(equalTo: cardDetailView.topAnchor, constant: 0)
        topTemporaryFix.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
        
        container.layoutIfNeeded()
        
        // ------------------------------
        // 1. Animate container bouncing up
        // ------------------------------
        func animateContainerBouncingUp() {
            animatedContainerVerticalConstraint.constant = 0
            container.layoutIfNeeded()
        }
        
        // ------------------------------
        // 2. Animate cardDetail filling up the container
        // ------------------------------
        func animateCardDetailViewSizing() {
            cardWidthConstraint.constant = animatedContainerView.bounds.width
            cardHeightConstraint.constant = animatedContainerView.bounds.height
            cardDetailView.layer.cornerRadius = 0
            container.layoutIfNeeded()
        }
        
        func completeEverything() {
            // Remove temporary `animatedContainerView`
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            // Re-add to the top
            container.addSubview(cardDetailView)
            cardDetailView.removeConstraints([topTemporaryFix, cardWidthConstraint, cardHeightConstraint])
            // Keep -1 to be consistent with the weird bug above.
            cardDetailView.edges(to: container, top: -1)
            // No longer need the bottom constraint that pins bottom of card content to its root.
            screens.cardDetail.scrollView.isScrollEnabled = true
            let success = !ctx.transitionWasCancelled
            ctx.completeTransition(success)
        }
        
        baseAnimator.addAnimations {
            
            // Spring animation for bouncing up
            animateContainerBouncingUp()
            
            // Linear animation for expansion
            let cardExpanding = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                animateCardDetailViewSizing()
            }
            cardExpanding.startAnimation()
        }
        
        baseAnimator.addCompletion { (_) in
            completeEverything()
        }
        
        self.animator = baseAnimator
    }
}

extension UIView {
    /// Constrain 4 edges of `self` to specified `view`.
    func edges(to view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
        ])
    }
}

extension UIImage {
    /// Resize UIImage to new width keeping the image's aspect ratio.
    func resize(toWidth scaledToWidth: CGFloat) -> UIImage {
        let image = self
        let oldWidth = image.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = image.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        let scaledSize = CGSize(width:newWidth, height:newHeight)
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
