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
    
    var dish: Dish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewBasics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
}

// MARK: - Setup Functions
extension DishViewController {
    
    private func setupViewBasics() {
        plateImageView.dropShadow()
        plateImageView.image = UIImage(named: "Plate")
    }
    
    private func setupViews() {
        topSection.backgroundColor = UIColor(hex: dish.color)
        foodImageView.image = UIImage(named: dish.image)
    }
}

// MARK: -
extension DishViewController {
    
}

// MARK: -
extension DishViewController {
    
}
