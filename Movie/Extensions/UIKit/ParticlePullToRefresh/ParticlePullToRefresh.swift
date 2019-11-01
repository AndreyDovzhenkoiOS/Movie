//
//  ParticlePullToRefresh.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ParticlePullToRefresh: UIControl {

    private enum RefreshState: Equatable {
        case initial
        case pulling(progress: CGFloat)
        case loading
        case completed
    }

    var action: VoidCallback?

    private let scrollView: UIScrollView
    private let color: UIColor
    private let threshold: CGFloat = 160
    private let refreshViewHeight: CGFloat = 120
    private var refreshState: RefreshState = .initial
    private var defaultContentOffset: CGPoint = .zero
    private var defaultContentInset: UIEdgeInsets = .zero
    private var contentOffsetObserver: NSKeyValueObservation?
    private var contentInsetObserver: NSKeyValueObservation?
    private var didSetDefaultContentArea = false
    private var canUpdateScrollViewInsets = true

    private let pointSize: CGFloat = 6
    private let pointLayer = CAShapeLayer()
    private var initialPosition: CGPoint!

    private let emitterLayer = CAEmitterLayer()
    private let circleLayer = CAShapeLayer()
    private let cell = CAEmitterCell()
    private let radius: CGFloat = 20
    private var centerX: CGFloat!
    private var centerY: CGFloat!
    private var path: UIBezierPath!

    init(color: UIColor, scrollView: UIScrollView) {
        self.scrollView = scrollView
        self.color = color
        super.init(frame: .zero)

        setupPointLayer()
        setupCircleLayer()
        registerObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unregisterObservers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !didSetDefaultContentArea {
            defaultContentOffset = scrollView.contentOffset
            defaultContentInset = scrollView.contentInset
            didSetDefaultContentArea = true
        }
    }

    func endRefreshing() {
        if refreshState == .loading {
            refreshState = .completed
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.contentInset = self.defaultContentInset
            self.resetAnimationState()
        }, completion: { _ in
            self.refreshState = .initial
            self.circleLayer.removeFromSuperlayer()
            self.emitterLayer.removeFromSuperlayer()
        })
    }

    private func setupPointLayer() {
        initialPosition = CGPoint(x: scrollView.bounds.width / 2 - pointSize / 2,
                                  y: refreshViewHeight / 2 - pointSize / 2)

        let origin: CGPoint = .zero
        let size = CGSize(width: pointSize, height: pointSize)

        pointLayer.path = UIBezierPath(ovalIn: CGRect(origin: origin, size: size)).cgPath
        pointLayer.fillColor = color.cgColor
        pointLayer.position = initialPosition
        pointLayer.opacity = 0
        layer.addSublayer(pointLayer)
    }

    private func setupCircleLayer() {
        centerX = scrollView.bounds.width / 2
        centerY = refreshViewHeight / 2
        path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )

        circleLayer.path = path.cgPath
        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 3
        circleLayer.strokeEnd = 0
        circleLayer.lineCap = CAShapeLayerLineCap.round

        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.point
        emitterLayer.emitterPosition = CGPoint(x: centerX, y: centerY - radius)

        cell.name = "particle"
        cell.birthRate = 300
        cell.lifetime = 0.7
        cell.velocity = 15
        cell.velocityRange = 10
        cell.scale = 0.12
        cell.scaleRange = 0.2
        cell.emissionRange = .pi
        cell.emissionLongitude = .pi
        cell.contents = UIImage.drawParticle(color: color).cgImage
        cell.alphaSpeed = -1/0.7
        emitterLayer.emitterCells = [cell]
    }

    private func calculatePullToRefreshFrame(
        for scrollView: UIScrollView,
        pullValue: CGFloat
        ) {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: scrollView.bounds.width,
            height: pullValue > 0 ? 0 : pullValue
        )
    }

    private func handlePullProgress(for scrollView: UIScrollView, pullValue: CGFloat) {
        guard pullValue < 0 else { return }

        let progress = (-pullValue / refreshViewHeight * 10).rounded(.toNearestOrAwayFromZero) / 10

        if progress <= 0 {
            pointLayer.opacity = 0
            pointLayer.position = initialPosition
        }

        if refreshState == .loading {
            emitterLayer.opacity = Float(progress)
            circleLayer.opacity = Float(progress)
        }

        if progress > 0 && refreshState != .loading {
            refreshState = .pulling(progress: progress)

            CATransaction.begin()
            pointLayer.opacity = Float(progress)
            pointLayer.position = CGPoint(x: pointLayer.position.x, y: refreshViewHeight / 2 - radius * progress)
            CATransaction.commit()
        }

        if progress >= 1 && scrollView.isDragging == false && refreshState != .loading {
            refreshState = .loading
            action?()

            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setCompletionBlock {
                self.pointLayer.opacity = 0
                self.showAnimatedCircle()
            }

            pointLayer.position = CGPoint(x: pointLayer.position.x, y: refreshViewHeight / 2 - radius)

            CATransaction.commit()

            let contentOffset = scrollView.contentOffset

            canUpdateScrollViewInsets = false

            UIView.animate(withDuration: 0.2) {
                let top = self.refreshViewHeight + self.defaultContentInset.top
                scrollView.contentInset.top = top
                scrollView.contentOffset = contentOffset
            }
        }
    }

    private func showAnimatedCircle() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(emitterLayer)

        let duration: CFTimeInterval = 1.4
        let delay = 0.1
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0, 0.1, 1)

        let positionAnimation = CAKeyframeAnimation(keyPath: "emitterPosition")
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.repeatCount = .infinity
        positionAnimation.beginTime = emitterLayer.convertTime(CACurrentMediaTime(), from: nil) + delay
        positionAnimation.timingFunction = timingFunction
        emitterLayer.add(positionAnimation, forKey: "emitterPosition")

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = duration
        strokeEndAnimation.repeatCount = .infinity
        strokeEndAnimation.beginTime = CACurrentMediaTime()
        strokeEndAnimation.timingFunction = timingFunction
        circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = duration
        strokeStartAnimation.repeatCount = .infinity
        strokeStartAnimation.beginTime = CACurrentMediaTime() + delay
        strokeStartAnimation.timingFunction = timingFunction
        circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
    }

    private func resetAnimationState() {
        pointLayer.position = initialPosition
        pointLayer.opacity = 0
        circleLayer.opacity = 0
        emitterLayer.opacity = 0
    }
}

extension ParticlePullToRefresh {

    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handerNotification),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)

        contentOffsetObserver = scrollView.observe(\.contentOffset, options: [.old, .new]) { [weak self]  in
            guard let strongSelf = self else { return }
            guard let oldValue = $1.oldValue else { return }
            guard let newValue = $1.newValue else { return }
            guard newValue != oldValue else { return }

            let pullValue = strongSelf.defaultContentInset.top + $0.safeAreaInsets.top + newValue.y

            strongSelf.calculatePullToRefreshFrame(for: $0, pullValue: pullValue)

            strongSelf.handlePullProgress(for: $0, pullValue: pullValue)
        }

        contentInsetObserver = scrollView.observe(\.contentInset, options: [.old, .new]) { [weak self] in
            guard let strongSelf = self else { return }
            guard let oldValue = $1.oldValue else { return }
            guard let newValue = $1.newValue else { return }
            guard newValue != oldValue else { return }

            if strongSelf.canUpdateScrollViewInsets && strongSelf.defaultContentInset != newValue {
                strongSelf.defaultContentInset = newValue
                strongSelf.resetAnimationState()
            }

            strongSelf.canUpdateScrollViewInsets = true
        }
    }

    private func setupAnimationMultiplelayerOperations() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        centerX = scrollView.bounds.width / 2
        centerY = refreshViewHeight / 2
        path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )

        circleLayer.path = path.cgPath
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterPosition = CGPoint(
            x: centerX,
            y: centerY - radius
        )

        initialPosition = CGPoint(
            x: scrollView.bounds.width / 2 - pointSize / 2,
            y: refreshViewHeight / 2 - pointSize / 2
        )

        CATransaction.commit()

        if refreshState == .loading {
            emitterLayer.removeAllAnimations()
            circleLayer.removeAllAnimations()
            showAnimatedCircle()
        }
    }

    @objc private func handerNotification() {
        setupAnimationMultiplelayerOperations()
    }

    private func unregisterObservers() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        contentOffsetObserver?.invalidate()
        contentInsetObserver?.invalidate()
    }
}
