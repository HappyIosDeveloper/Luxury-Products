//
//  ViewController.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dishes: [Dish] = []
    private var isScrollingUp = false
    private var transition: CardTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - Setup Functions
extension ViewController {
    
    private func setupView() {
        setupNavigationBar()
        fillItems()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Luxury Dishes"
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: CustomCell.id, bundle: nil), forCellReuseIdentifier: CustomCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        DispatchQueue.main.async {
            self.tableView.reloadWithAnimation()
        }
    }
    
    private func fillItems() {
        dishes = [
            Dish(name: "Bluefin Tuna", price: "$1,000", color: "FFBF69", image: "1", details: Dish.kobeDetails),
            Dish(name: "Iberico Ham", price: "$2,300", color: "2EC4B6", image: "2", details: Dish.ibericoHamDetails),
            Dish(name: "Kopi Luwak Coffee", price: "$9,800", color: "dabbed", image: "3", details: Dish.kopiLuwakCoffeeDetails),
            Dish(name: "Matsutake Mushrooms", price: "$1,900", color: "beefed", image: "4", details: Dish.matsutakeMushroomsDetails),
            Dish(name: "Beluga Caviar", price: "$1,400", color: "FF6B6B", image: "5", details: Dish.belugaCaviarDetails),
            Dish(name: "White Truffles", price: "$1,500", color: "beaded", image: "6", details: Dish.whiteTrufflesDetails),
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
        playThickSound()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCell.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = tableView.panGestureRecognizer.translation(in: scrollView.superview)
        isScrollingUp = translation.y > 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTapAction(for: indexPath)
    }
}


// MARK: - Actions
extension ViewController {
    
    private func cellTapAction(for indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        cell.freezeAnimations()
        // Convert current frame to screen's coordinates
        let cardPresentationFrameOnScreen = tableView.convert(cell.frame, to: view)
        // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.frame.size
            let rect = CGRect(x: center.x - size.width / 2, y: center.y - (size.height / 2), width: size.width * 0.9, height: size.height * 0.9)
            return tableView.convert(rect, to: nil)
        }()
        // Set up card detail view controller
        let vc = storyboard?.instantiateViewController(withIdentifier: "DishViewController") as! DishViewController
        vc.dish = dishes[indexPath.row]
        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen, fromCardFrameWithoutTransform: cardFrameWithoutTransform, fromCell: cell)
        transition = CardTransition(params: params)
        vc.transitioningDelegate = transition
        // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: { [weak cell] in
            cell?.unfreezeAnimations()
        })
    }
    
    private func playThickSound() {
        AudioServicesPlayAlertSound(SystemSoundID(1104))
        // let generator = UIImpactFeedbackGenerator(style: .light)
        // generator.impactOccurred()
    }
}
