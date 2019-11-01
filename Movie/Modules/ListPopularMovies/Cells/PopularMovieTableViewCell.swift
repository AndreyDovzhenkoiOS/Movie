//
//  PopularMovieTableViewCell.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class PopularMovieTableViewCell: UITableViewCell {

    private let containerView = UIView().thenUI {
        $0.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.3176470588, blue: 0.462745098, alpha: 1)
        $0.layer.cornerRadius = 15
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        configureContainerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureContainerView() {
        addSubview(containerView)
        containerView.left(12).right(12).top(10).bottom()
    }
}
