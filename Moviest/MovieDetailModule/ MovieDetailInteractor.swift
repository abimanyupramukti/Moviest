//
//   MovieDetailInteractor.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 15/09/23.
//

import Foundation

class MovieDetailInteractor {
    
    private let service: MovieService
    
    init(service: MovieService = MovieService()) {
        self.service = service
    }
    
    func fetchDetail(movieID: Int) async throws -> Movie {
        return try await service.fetchMovie(id: movieID)
    }
    
    func fetchMoreReviews(movieID: Int, page: Int) async throws -> [Review] {
        let response = try await service.fetchReviews(movieID: movieID, page: page)
        return response.results
    }
}
