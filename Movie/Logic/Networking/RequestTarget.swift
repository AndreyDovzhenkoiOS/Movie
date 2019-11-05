//
//  RequestTarget.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum RequestTarget {
    case popularMovies(page: Int)
    case markAsFavorite(sessionId: String, accountId: Int, movieId: Int, favorite: Bool)
}

extension RequestTarget {
    enum HTTPMethod: String {
        case get, post
    }

    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        case .markAsFavorite( _, let accountId, _, _):
            return "/3/account/\(accountId)/favorite"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .popularMovies:
            return .get
        case .markAsFavorite:
            return .post
        }
    }

    var parameters: [String: String] {
        switch self {
        case let .popularMovies(page):
            return ["page": String(page)]
        case .markAsFavorite(let sessionId, _, let movieId, let favorite):
            let queryParams: [String: Any] = ["session_id": sessionId]
            let bodyParams: [String: Any] = ["media_type": "movie",
                                             "media_id": movieId,
                                             "favorite": favorite]
            return ["query": "", "body": ""]
        }
    }
}
