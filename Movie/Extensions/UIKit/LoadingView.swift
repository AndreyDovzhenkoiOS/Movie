//
//  LoadingView.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    private enum Constants {
        static let beginTime: CFTimeInterval = 0.5
        static let strokeStartDuration: CFTimeInterval = 1.2
        static let strokeEndDuration: CFTimeInterval = 0.7
    }

    var color: UIColor = .white
    var lineWidth: CGFloat = 1
    var speed: Float = 1

    private(set) var isAnimating: Bool = false

    private enum AnimattionType {
        case transformRotation
        case strokeStart
        case strokeEnd

        var value: String {
            switch self {
            case .transformRotation:
                return "transform.rotation"
            case .strokeStart:
                return "strokeStart"
            case .strokeEnd:
                return "strokeEnd"
            }
        }
    }

    override var bounds: CGRect {
        didSet {
            if oldValue != bounds && isAnimating {
                setupAnimation()
            }
        }
    }

    func startAnimating() {
        if !isAnimating {
            isHidden = false
            isAnimating = true
            layer.speed = speed
            setupAnimation()
        }
    }

    func stopAnimating() {
        if isAnimating {
            isHidden = true
            isAnimating = false
            layer.sublayers?.removeAll()
        }
    }

    private func setupAnimation() {
        let minEdge = min(frame.width, frame.height)
        layer.sublayers = nil
        let animationSize = CGSize(width: minEdge, height: minEdge)
        setupAnimation(in: layer, size: animationSize, color: color)
    }

    private func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let rotationAnimation = CABasicAnimation(keyPath: AnimattionType.transformRotation.value)
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [
            rotationAnimation, strokeAnimation(type: .strokeEnd),
            strokeAnimation(type: .strokeStart)
        ]
        groupAnimation.duration = Constants.strokeStartDuration + Constants.beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards

        let circle = layerWith(size: size, color: color)
        let frame = CGRect(
            x: (layer.bounds.width - size.width) / 2,
            y: (layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        circle.frame = frame
        circle.add(groupAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }

    private func strokeAnimation(type: AnimattionType) -> CABasicAnimation {
        let strokeAnimation = CABasicAnimation(keyPath: type.value)
        strokeAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1

        switch type {
        case .strokeStart:
            strokeAnimation.duration = Constants.strokeStartDuration
            strokeAnimation.beginTime = Constants.beginTime
        case .strokeEnd:
            strokeAnimation.duration = Constants.strokeEndDuration
        default:
            break
        }

        return strokeAnimation
    }

    private func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: -(.pi / 2),
                    endAngle: .pi + .pi / 2,
                    clockwise: true)

        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
}
