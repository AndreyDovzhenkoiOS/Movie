//
//  UIScrollView+ParticlePullToRefresh.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

private var assosiationKey: UInt8 = 0

extension UIScrollView {
    func addParticlePullToRefresh(color: UIColor = .gray, action: @escaping () -> Void) {
        if particlePullToRefresh != nil {
            removeParticlePullToRefresh()
        }

        particlePullToRefresh = ParticlePullToRefresh(color: color, scrollView: self)
        particlePullToRefresh?.action = action
        addSubview(particlePullToRefresh!)
    }

    func removeParticlePullToRefresh() {
        particlePullToRefresh?.removeFromSuperview()
        particlePullToRefresh = nil
    }

    private(set) var particlePullToRefresh: ParticlePullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &assosiationKey) as? ParticlePullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &assosiationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
