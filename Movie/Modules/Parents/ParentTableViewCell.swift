//
//  ParentTableViewCell.swift
//  Movie
//
//  Created by Andrey on 11/4/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

class ParentTableViewCell: UITableViewCell {

    private let lineView = UIView().thenUI {
        $0.alpha = 0.5
        $0.backgroundColor = Asset.white.color
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureLineView() {
        addSubview(lineView)
        lineView.height(1).left(18).right().bottom()
    }
}
