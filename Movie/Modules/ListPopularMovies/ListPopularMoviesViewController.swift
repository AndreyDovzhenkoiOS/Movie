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
        view.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1450980392, alpha: 1)
        configurePullToRefresh()
        configureTableView()
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

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.withoutSafeArea { $0.pin() }
    }

    private func configurePullToRefresh() {
        tableView.addParticlePullToRefresh(color: #colorLiteral(red: 0.4274509804, green: 0.8266684322, blue: 1, alpha: 1)) { [weak self] in
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

extension ListPopularMoviesViewController: ListPopularMoviesPresenterDelegate {

}
