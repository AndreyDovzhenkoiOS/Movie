//
//  ListMovies.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

struct ListMovies: Codable {
    let page: Int
    let totalPages: Int?
    let results: [Movie]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}
