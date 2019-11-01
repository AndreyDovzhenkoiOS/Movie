//
//  ViewController.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ListPopularMoviesViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain).thenUI {
        $0.rowHeight = 100
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(PopularMovieTableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.2549019608, blue: 0.3803921569, alpha: 1)
        configureTableView()
        configurePullToRefresh()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.withoutSafeArea { $0.pin() }
    }

    private func configurePullToRefresh() {
        tableView.addParticlePullToRefresh(color: #colorLiteral(red: 0.3803921569, green: 0.8117647059, blue: 0.6078431373, alpha: 1)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.tableView.particlePullToRefresh?.endRefreshing()
            }
        }
    }
}

extension ListPopularMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as PopularMovieTableViewCell
        return cell
    }

}

extension ListPopularMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
