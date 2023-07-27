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
    
    let colors = ["feeded", "decade", "dabbed", "beefed", "beaded"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        contentView.clipsToBounds = false
        selectionStyle = .none
        parentView.dropMiniShadow()
        plateImageView.dropShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        parentView.layer.cornerRadius = parentView.frame.height / 2
        contentView.layoutIfNeeded()
    }
}

// MARK: - Setup Functions
extension CustomCell {
    
    func setup(item: String) {
        foodImageView.image = UIImage(named: item)
        parentView.backgroundColor = UIColor(hex: colors.randomElement()!)
        dishParentView.dishAppearEffect()
        foodImageView.rotate()
        //        applyCornersEffect()
    }
    
    
//    private func applyCornersEffect() {
//        parentView.layer.cornerRadius = bounds.height / 4
//        UIView.animate(withDuration: 1) { [self] in
//            parentView.layer.cornerRadius = bounds.height / 2.2
//        }
//    }
}
