//
//  UITableView.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadWithAnimationFadeInTop() {
        reloadData()

        for (index, cell) in visibleCells.enumerated() {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 1,
                           delay: 0.1 * Double(index),
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.1,
                           options: [.curveLinear],
                           animations: {
                    cell.alpha = 1
                    cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
}
