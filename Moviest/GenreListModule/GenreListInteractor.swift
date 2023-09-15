//
//  GenreListInteractor.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import Foundation

class GenreListInteractor {
    
    private let service: MovieService
    
    init(service: MovieService = MovieService()) {
        self.service = service
    }
    
    func fetchGenres() async throws  -> [Genre] {
        let response = try await service .fetchGenres()
        return response.genres
    }
}
