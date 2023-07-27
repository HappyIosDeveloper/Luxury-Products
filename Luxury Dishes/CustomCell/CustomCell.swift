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
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var dishParentView: UIView!
    @IBOutlet weak var plateImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: CircularLabel!
    @IBOutlet weak var dishPriceLabel: CircularLabel!

    let colors = ["feeded", "decade", "dabbed", "beefed", "beaded"]
    let dishNames = ["Bluefin Tuna", "Iberico Ham", "Kopi Luwak Coffee", "Matsutake Mushrooms", "Saffron", "Beluga Caviar"]
    let prices = ["$1,000", "$2,300", "$1,400", "$9,800", "$1,900", "$1,500"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        basicViewSetups()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCell()
    }
}

// MARK: - Setup Functions
extension CustomCell {
    
    private func basicViewSetups() {
        clipsToBounds = false
        contentView.clipsToBounds = false
        selectionStyle = .none
        parentView.dropMiniShadow()
        plateImageView.dropShadow()
        dishNameLabel.textColor = .darkText
        dishNameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        dishPriceLabel.textColor = .darkText
        dishPriceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
    }
    
    private func roundCell() {
        parentView.layer.cornerRadius = parentView.frame.height / 2
        contentView.layoutIfNeeded()
    }
    
    func setup(item: String) {
        foodImageView.image = UIImage(named: item)
        dishNameLabel.text = dishNames.randomElement()!
        dishPriceLabel.text = prices.randomElement()!
        parentView.backgroundColor = UIColor(hex: colors.randomElement()!)
        dishParentView.dishAppearEffect()
        foodImageView.rotate()
        dishNameLabel.textRotateTop()
        dishPriceLabel.textRotateBottom()
    }
}
