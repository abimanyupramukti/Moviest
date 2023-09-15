//
//  MovieListPresenter.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

class MovieListPresenter: ObservableObject {
    
    var genreName: String {
        genre.name
    }
    
    @Published var movies: [Movie]?
    @Published var moviesError: Error?
    
    @Published var isFetching = false
    @Published var isFetchingMore = false
    @Published var isMaxItem: Bool = false
    
    private var page: Int = 1
    private let maximumPage = 500
    
    private let genre: Genre
    private let interactor: MovieListInteractor
    private let router: MovieListRouter
    
    init(genre: Genre, interactor: MovieListInteractor, router: MovieListRouter = MovieListRouter()) {
        self.genre = genre
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor func fetchMovies() async {
        guard !isFetching else { return }
        
        defer { isFetching = false }
        isFetching = true
        
        movies = nil
        moviesError = nil
        page = 1
        
        do {
            let fetchedMovies = try await loadMovies()
            movies = fetchedMovies
        } catch(let error) {
            moviesError = error
        }
    }
    
    @MainActor func fetchMore() async {
        // TODO: - limit API calls based on resource capability.
        guard !isFetchingMore, !isMaxItem else { return }
        
        defer { isFetchingMore = false }
        isFetchingMore = true
        
        do {
            let fetchedMovies = try await loadMovies()
            isMaxItem = (page > maximumPage || fetchedMovies.isEmpty)
            
            if !fetchedMovies.isEmpty {
                movies?.append(contentsOf: fetchedMovies)
            }
            
        } catch(let error) {
            // TODO: - handle error with better design.
            print(error.localizedDescription)
        }
    }
    
    private func loadMovies() async throws -> [Movie] {
        let fetchedMovies = try await interactor.fetchMovieList(genreID: genre.id, page: page)
        page += 1
        return fetchedMovies
    }
    
    func presentMovieDetailView(id: Int) -> some View {
        router.makeMovieDetailView(for: id)
    }
}
