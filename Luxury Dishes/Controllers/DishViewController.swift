//
//  DishViewController.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/27/23.
//

import UIKit

class DishViewController: UIViewController {
    
    @IBOutlet weak var topSection: UIView!
    @IBOutlet weak var plateImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var nameLabel: CircularLabel!
    @IBOutlet weak var priceLabel: CircularLabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var dish: Dish!
    private var interactiveStartingPoint: CGPoint?
    private var dismissalAnimator: UIViewPropertyAnimator?
    private lazy var dismissalPanGesture: DismissalPanGesture = {
        let pan = DismissalPanGesture()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    private lazy var dismissalScreenEdgePanGesture: DismissalScreenEdgePanGesture = {
        let pan = DismissalScreenEdgePanGesture()
        pan.edges = .left
        return pan
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewBasics()
        setupDismissFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 1) {
            self.topSection.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
}

// MARK: - Setup Functions
extension DishViewController {
    
    private func setupViewBasics() {
        plateImageView.dropShadow(isForceShrink: true)
        plateImageView.image = UIImage(named: "Plate")
        foodImageView.transform = CGAffineTransform(rotationAngle: .pi)
        nameLabel.textColor = .darkText
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        priceLabel.textColor = .darkText
        priceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
    }
    
    private func setupViews() {
        topSection.backgroundColor = UIColor(hex: dish.color)
        foodImageView.image = UIImage(named: dish.image)
        nameLabel.text = dish.name
        priceLabel.text = dish.name.compactMap({_ in "   "}).joined() + dish.price
        nameLabel.infiniteRotation()
        priceLabel.infiniteRotation()
        foodImageView.popIn()
        plateImageView.popIn()
    }
}

// MARK: -
extension DishViewController {
    
}

// MARK: - Dismiss Functions
extension DishViewController: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    private func setupDismissFunctions() {
        if GlobalConstants.isEnabledDebugAnimatingViews {
            scrollView.layer.borderWidth = 3
            scrollView.layer.borderColor = UIColor.green.cgColor
            scrollView.subviews.first!.layer.borderWidth = 3
            scrollView.subviews.first!.layer.borderColor = UIColor.purple.cgColor
        }
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self
        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)
        loadViewIfNeeded()
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
        view.clipsToBounds = true // to handle corner radius while shrinking
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
        let targetAnimatedView = gesture.view!
        let startingPoint: CGPoint
        if let p = interactiveStartingPoint {
            startingPoint = p
        } else {
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }
        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        let targetShrinkScale: CGFloat = 0.9
        let targetCornerRadius: CGFloat = GlobalConstants.cardCornerRadius

        func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
            if let animator = dismissalAnimator {
                return animator
            } else {
                let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                    targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = targetCornerRadius
                })
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = progress
                return animator
            }
        }

        switch gesture.state {
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
        case .changed:
            textAlphas(set: 0)
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0
            dismissalAnimator!.fractionComplete = actualProgress
            if isDismissalSuccess {
                dismissalAnimator!.stopAnimation(false)
                dismissalAnimator!.addCompletion { [unowned self] (pos) in
                    switch pos {
                    case .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator!.finishAnimation(at: .end)
            }
        case .ended, .cancelled:
            if dismissalAnimator == nil {
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }
            // NOTE:
            // If user lift fingers -> ended
            // If gesture.isEnabled -> cancelled
            // Ended, Animate back to start
            dismissalAnimator!.pauseAnimation()
            dismissalAnimator!.isReversed = true
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            dismissalAnimator!.addCompletion { [unowned self] (pos) in
                self.didCancelDismissalTransition()
                gesture.isEnabled = true
                textAlphas(set: 1)
            }
            dismissalAnimator!.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }
    
    private func didSuccessfullyDragDownToDismiss() {
        dismiss(animated: true)
    }
    
    private func didCancelDismissalTransition() {
        interactiveStartingPoint = nil
        dismissalAnimator = nil
    }
    
    private func textAlphas(set to: Double) {
        UIView.animate(withDuration: 0.3) {
            self.priceLabel.alpha = to
            self.nameLabel.alpha = to
        }
    }
}

final class DismissalPanGesture: UIPanGestureRecognizer {}
final class DismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer {}
