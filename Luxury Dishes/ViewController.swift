//
//  ViewController.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var items: [String] = []
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
        items = Array(1...6).compactMap({$0.description})
        for _ in 0...10 {
            items += items
        }
    }
}

// MARK: - TableView Functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as! CustomCell
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.parentAppearEffect(isScrollingUp: isScrollingUp)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width - (CustomCell.margin * 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = tableView.panGestureRecognizer.translation(in: scrollView.superview)
        isScrollingUp = translation.y > 0
    }
}
