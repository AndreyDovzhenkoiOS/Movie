//
//  Movie.swift
//  Movie
//
//  Created by Andrey on 11/3/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

struct Movie: Codable {
    var id: Int?
    var title: String?
    var releaseDate: String?
    var overview: String?
    var voteAverage: CGFloat?
    var posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
