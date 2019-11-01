//
//  CALayer.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension CALayer {
    func setupShadow(radius: CGFloat, opacity: Float, height: CGFloat) {
        shouldRasterize = true
        masksToBounds = false
        shadowRadius = radius
        shadowOpacity = opacity
        rasterizationScale = UIScreen.main.scale
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: height)
    }
}
