//
//  CustomCell.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

class CustomCell: UITableViewCell {

    static let id = "CustomCell"

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Setup Functions
extension CustomCell {
    
    func setup(item: String) {
        foodImageView.image = UIImage(named: item)
        parentView.backgroundColor = [UIColor.black, .gray, .red, .blue, .brown, .cyan, .green].randomElement()!
        parentView.layer.cornerRadius = 20
        
    }
}
