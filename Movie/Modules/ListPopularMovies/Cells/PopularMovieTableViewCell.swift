//
//  PopularMovieTableViewCell.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class PopularMovieTableViewCell: ParentTableViewCell {

    private let ratingView = RatingView().thenUI {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 25
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }

    private let containerView = UIView().thenUI {
        $0.layer.setupShadow(radius: 18, opacity: 0.8, height: 18)
    }

    private let iconImageView = LoadingImageView(frame: .zero).thenUI {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.contentMode = .scaleAspectFill
    }

    private let favoriteButton = UIButton().thenUI {
        $0.setImage(Asset.favoriteOff.image, for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContainerView()
        configureIconImageView()
        configureRatingView()
        configureFavoriteButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with movie: Movie?) {
        guard let posterPath = movie?.posterPath,
            let url = URL(string: URLConfiguration.mediaBackdropPath + posterPath) else {
                return
        }
        iconImageView.loadImage(url)
        ratingView.configure(with: movie?.voteAverage ?? 0)
    }

    private func configureContainerView() {
        addSubview(containerView)
        containerView.left(30).right(30).top(12).bottom(8)
    }

    private func configureIconImageView() {
        containerView.addSubview(iconImageView)
        iconImageView.pin()
    }

    private func configureRatingView() {
        containerView.addSubview(ratingView)
        ratingView.left(20).top(16).height(50).aspectRatio()
    }

    private func configureFavoriteButton() {
        containerView.addSubview(favoriteButton)
        favoriteButton.right(20).top(16).height(50).aspectRatio()

        favoriteButton.addAction(for: .touchUpInside) {
            guard let sender = $0 as? UIButton else { return }
            sender.setImage(Asset.favoriteOn.image, for: .normal)
        }
    }
}
