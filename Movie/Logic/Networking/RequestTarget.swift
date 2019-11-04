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
}

extension RequestTarget {
    enum HTTPMethod: String {
        case get, post
    }

    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .popularMovies:
            return .get
        }
    }

    var parameters: [String: String] {
        switch self {
        case let .popularMovies(page):
            return ["page": String(page)]
        }
    }
}
