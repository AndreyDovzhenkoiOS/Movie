//
//  Typealiases.swift
//  Movie
//
//  Created by Andrey on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

typealias VoidCallback = () -> Void
typealias Callback<T> = (T) -> Void
typealias RequestResult<T, E> = (T, E) -> Void
typealias RequestResultProvider = (Swift.Result<Data, Error>) -> Void
