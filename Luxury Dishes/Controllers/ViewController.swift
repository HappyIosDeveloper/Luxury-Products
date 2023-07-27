//
//  ViewController.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dishes: [Dish] = []
    private var isScrollingUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - Setup Functions
extension ViewController {
    
    func setupView() {
        setupNavigationBar()
        fillItems()
        setupTableView()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Luxury Dishes"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: CustomCell.id, bundle: nil), forCellReuseIdentifier: CustomCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fillItems() {
        dishes = [
            Dish(name: "Bluefin Tuna", price: "$1,000", color: "feeded", image: "1"),
            Dish(name: "Iberico Ham", price: "$2,300", color: "decade", image: "2"),
            Dish(name: "Kopi Luwak Coffee", price: "$9,800", color: "dabbed", image: "3"),
            Dish(name: "Matsutake Mushrooms", price: "$1,900", color: "beefed", image: "4"),
            Dish(name: "Beluga Caviar", price: "$1,400", color: "beaded", image: "5"),
            Dish(name: "White Truffles", price: "$1,500", color: "beaded", image: "6"),
        ]
        for _ in 0...10 {
            dishes += dishes
        }
    }
}

// MARK: - TableView Functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as! CustomCell
        cell.setup(dish: dishes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.parentAppearEffect(isScrollingUp: isScrollingUp)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCell.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = tableView.panGestureRecognizer.translation(in: scrollView.superview)
        isScrollingUp = translation.y > 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DishViewController") as! DishViewController
        vc.dish = dishes[indexPath.row]
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
}
