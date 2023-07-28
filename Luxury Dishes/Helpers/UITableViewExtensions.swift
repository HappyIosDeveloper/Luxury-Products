//
//  UITableViewHighlightEffect.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/27/23.
//

import UIKit

extension UITableView {
    
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.2, delay: 0.5 * Double(delayCounter), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

extension ViewController {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.tag != 123 {
                cell.tag = 123
                UIView.animate(withDuration: 0.4) {
                    cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 1.2)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                cell.layer.transform = CATransform3DIdentity
            }) { (_) in
                cell.tag = 0
            }
        }
    }
}

