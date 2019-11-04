//
//  NetworkService.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
  func getListMovies(page: Int, completion: @escaping RequestResult<ListMovies?, Error?>)
}

final class NetworkService: NetworkServiceProtocol {

    private let provider: RequestProviderProtocol

    init(provider: RequestProviderProtocol) {
        self.provider = provider
    }

    func getListMovies(page: Int, completion: @escaping RequestResult<ListMovies?, Error?>) {
        provider.request(target: .popularMovies(page: page),
                         type: ListMovies.self,
                         completion: completion)
    }
}
