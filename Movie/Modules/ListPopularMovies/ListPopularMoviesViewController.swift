//
//  ViewController.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ListPopularMoviesViewController: ParentViewController {

    private enum Constants {
        static let headerHeight: CGFloat = 115
        static let cellHeight: CGFloat = 500
        static let bottomGradientViewHeight: CGFloat = 100
    }

    private let headerView = HeaderView().thenUI {
        $0.backgroundColor = .clear
    }

    private let gradientlayer = CAGradientLayer().then {
        let colors = [Asset.darkGreen.color.cgColor, Asset.mediumGreen.color.cgColor]
        $0.setupGradient(start: .topCenter, end: .bottomLeft, colors: colors)
    }

    private let tableView = UITableView(frame: .zero, style: .plain).thenUI {
        $0.rowHeight = Constants.cellHeight
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(PopularMovieTableViewCell.self)
    }

    private let bottomGradientView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }

    private let bottomGradientLayer = CAGradientLayer().then {
        let colors = [Asset.blackOpacity.color.cgColor, Asset.mediumGreenOpacity.color.cgColor]
        $0.setupGradient(start: .topCenter, end: .bottomCenter, colors: colors)
    }

    override var navigationBarHidesShadow: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradientlayer)
        configureHeaderView()
        configurePullToRefresh()
        configureTableView()
        configureBottomGradientView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientlayer.frame = view.frame
        bottomGradientLayer.frame = bottomGradientView.frame
        bottomGradientLayer.frame.origin.y = 0
    }

    let presenter: ListPopularMoviesPresenter

    init(presenter: ListPopularMoviesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHeaderView() {
        view.addSubview(headerView)
        headerView.configure(with: "Popular movies")

        headerView.withoutSafeArea {
            $0.top().left().right().height(Constants.headerHeight)
        }
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.withoutSafeArea {
            $0.left().right().bottom()
            $0.topAnchor ~ headerView.bottomAnchor
        }
    }

    private func configurePullToRefresh() {
        tableView.addParticlePullToRefresh(color: Asset.lightGreen.color) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.tableView.particlePullToRefresh?.endRefreshing()
            }
        }
    }

    private func configureBottomGradientView() {
        view.addSubview(bottomGradientView)
        bottomGradientView.withoutSafeArea {
            $0.left().right().bottom().height(Constants.bottomGradientViewHeight)
        }
        bottomGradientView.layer.addSublayer(bottomGradientLayer)
    }
}

extension ListPopularMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listMovies?.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(for: indexPath) as PopularMovieTableViewCell).then {
            $0.configure(with: presenter.listMovies?.results?[indexPath.row])
        }
    }

}

extension ListPopularMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ListPopularMoviesViewController: ListPopularMoviesPresenterDelegate {
    func updateCells() {
        tableView.particlePullToRefresh?.endRefreshing()
        tableView.reloadWithAnimationFadeInTop()
    }
}
