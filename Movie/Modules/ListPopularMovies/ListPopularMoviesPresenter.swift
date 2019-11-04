//
//  ListPopularMoviesPresenter.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

protocol ListPopularMoviesPresenterDelegate: class {
    func updateCells()
}

final class ListPopularMoviesPresenter {

    let service: NetworkServiceProtocol

    weak var delegate: ListPopularMoviesPresenterDelegate?

    var listMovies: ListMovies?

    init(service: NetworkServiceProtocol) {
        self.service = service
        self.requestListMovies()
    }

    private func handlerReuqestListMovies(listMovies: ListMovies?) {
        self.listMovies = listMovies
        delegate?.updateCells()
    }
}

extension ListPopularMoviesPresenter {
    func requestListMovies() {
        service.getListMovies(page: 1) { [weak self] listMovies, error in
            self?.handlerReuqestListMovies(listMovies: listMovies)
        }
    }
}
