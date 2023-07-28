//
//  CustomCell.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

final class CustomCell: UITableViewCell {
    
    static let id = "CustomCell"
    static let margin: CGFloat = 30
    static let cellHeight: CGFloat = UIScreen.main.bounds.width - (margin * 2)
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var dishParentView: UIView!
    @IBOutlet weak var plateImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var nameLabel: CircularLabel!
    @IBOutlet weak var priceLabel: CircularLabel!
    
    var dish: Dish!
    private var disabledHighlightedAnimation = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        basicViewSetups()
    }
}

// MARK: - Setup Functions
extension CustomCell {
    
    private func basicViewSetups() {
        clipsToBounds = false
        contentView.clipsToBounds = false
        selectionStyle = .none
        parentView.dropShadowAndCornerRadius(bounds.width / 5)
        plateImageView.dropShadow()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        priceLabel.textColor = .white
        priceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        plateImageView.addParallax(range: 20)
        foodImageView.addParallax(range: -20)
    }
    
    func setup(dish: Dish) {
        self.dish = dish
        foodImageView.image = UIImage(named: dish.image)
        nameLabel.text = dish.name
        priceLabel.text = dish.price
        parentView.backgroundColor = UIColor(hex: dish.color)
        dishParentView.dishAppearEffect()
        foodImageView.rotate()
        nameLabel.textRotateTop()
        priceLabel.textRotateBottom()
    }
}

// MARK: - Animation Stuff
extension CustomCell {
    
    func resetTransform() {
        transform = .identity
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation { return }
        let animationOptions: UIView.AnimationOptions = GlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .init(scaleX: GlobalConstants.cardHighlightedFactor, y: GlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
}
