//
//  RatingView.swift
//  Movie
//
//  Created by Andrey on 11/4/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class RatingView: UIView {

    private let circulView = UIView().thenUI {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }

    private let numberLabel = UILabel().thenUI {
        $0.font = UIFont.system(.bold, size: 14)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCircularView()
        configureNumberLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rating: CGFloat ) {
        isHidden = Int(rating) <= 0
        numberLabel.text = "\(rating)"
    }

    private func configureCircularView() {
        addSubview(circulView)
        circulView.centerX().centerY().height(40).aspectRatio()
    }

    private func configureNumberLabel() {
        circulView.addSubview(numberLabel)
        numberLabel.pin()
    }
}
