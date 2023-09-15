//
//  Stub.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import Foundation

extension Movie {
    static let stubbedMovies: [Movie] = {
        let response: MovieResponse = Bundle.main.loadAndDecodeJSON(filename: "movies")!
        return response.results
    }()
    
    static let stubbedMovie: Movie = {
        return stubbedMovies[0]
    }()
}
