//
//  GenreListPresenter.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

class GenreListPresenter: ObservableObject {
    
    @Published var genres: [Genre]?
    @Published var genresError: Error?
    
    private let interactor: GenreListInteractor
    private let router: GenreListRouter
    
    init(interactor: GenreListInteractor, router: GenreListRouter = GenreListRouter()) {
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor func fetchGenres() async {
        genres = nil
        genresError = nil
        
        do {
            genres = try await interactor.fetchGenres()
        } catch(let error) {
            genresError = error
        }
    }
    
    func presentMovieListView(genre: Genre) -> some View {
        router.makeMovieListView(for: genre)
    }
}
