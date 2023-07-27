//
//  CustomCell.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

class CustomCell: UITableViewCell {

    static let id = "CustomCell"
    static let margin: CGFloat = 30
    static let cellHeight: CGFloat = UIScreen.main.bounds.width - (margin * 2)
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var dishParentView: UIView!
    @IBOutlet weak var plateImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: CircularLabel!
    @IBOutlet weak var dishPriceLabel: CircularLabel!
    
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
        dishNameLabel.textColor = .darkText
        dishNameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        dishPriceLabel.textColor = .darkText
        dishPriceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
    }
    
    func setup(dish: Dish) {
        foodImageView.image = UIImage(named: dish.image)
        dishNameLabel.text = dish.name
        dishPriceLabel.text = dish.price
        parentView.backgroundColor = UIColor(hex: dish.color)
        dishParentView.dishAppearEffect()
        foodImageView.rotate()
        dishNameLabel.textRotateTop()
        dishPriceLabel.textRotateBottom()
    }
}
