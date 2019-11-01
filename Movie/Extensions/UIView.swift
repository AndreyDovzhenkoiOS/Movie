//
//  UIView.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UIView {
    func roundTop(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    func pulsate() {
        let pulsate = CASpringAnimation(keyPath: "transform.scale").then {
            $0.duration = 0.2
            $0.fromValue = 0.95
            $0.toValue = 1.0
            $0.autoreverses = true
            $0.repeatCount = 1
            $0.initialVelocity = 0.5
            $0.damping = 1.0
        }
        layer.add(pulsate, forKey: "pulse")
    }

    func transform(with cordinate: CGFloat, center: CGPoint) {
        transform = CGAffineTransform(scaleX: cordinate, y: cordinate)
        self.center = center
    }
}
