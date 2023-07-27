//
//  UITableViewHighlightEffect.swift
//  Luxury Dishes
//
//  Created by Ahmadreza on 7/27/23.
//

import UIKit

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

