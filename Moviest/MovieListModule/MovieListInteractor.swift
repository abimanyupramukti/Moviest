//
//  MovieListInteractor.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import Foundation

class MovieListInteractor {
    
    private let service: MovieService
    
    init(service: MovieService = MovieService()) {
        self.service = service
    }
    
    func fetchMovieList(genreID: Int, page: Int) async throws -> [Movie] {
        let response = try await service.searchMovie(genreID: genreID, page: page)
        return response.results
    }
}
