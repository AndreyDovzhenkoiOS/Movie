//
//  Movie.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

struct Movie: Codable {
    let id: Int?
    let title: String?
    let releaseDate: String?
    let overview: String?
    let voteAverage: CGFloat?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
