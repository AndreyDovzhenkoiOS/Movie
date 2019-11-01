//
//  UIControl.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UIControl {
    typealias UIControlTargetClosure = Callback<UIControl>?

    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure

        init(_ closure: UIControlTargetClosure) {
            self.closure = closure
        }
    }

    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }

    private var targetClosure: UIControlTargetClosure? {
        get {
            let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure)
            guard let wrapper = closureWrapper as? UIControlClosureWrapper else {
                return nil
            }
            return wrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure,
                                     UIControlClosureWrapper(newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addAction(for event: UIControl.Event, closure: UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }

    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure?(self)
    }
}
