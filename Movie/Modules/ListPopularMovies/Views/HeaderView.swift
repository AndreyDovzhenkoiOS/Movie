//
//  HeaderView.swift
//  Movie
//
//  Created by Andrey on 11/4/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class HeaderView: UIView {

    private let titleLabel = UILabel().thenUI {
        $0.textColor = Asset.white.color
        $0.font = UIFont.system(.bold, size: 30)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitleLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.left(20).bottom(8).right().height(30)
    }
}
