//
//   MovieDetailPresenter.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 15/09/23.
//

import Foundation
import SwiftUI

class MovieDetailPresenter: ObservableObject {
    
    @Published var movie: Movie?
    @Published var movieError: Error?
    
    @Published var reviews: [Review] = []
    
    @Published var selectedTrailer: Video?
    @Published var expandedReviews: [Review] = []
    @Published var isMaxItem: Bool = false
    
    private var page = 2
    private let maximumPage = 500
    
    private let movieID: Int
    private let interactor: MovieDetailInteractor
    private let router: MovieDetailRouter
    
    init(movieID: Int, interactor: MovieDetailInteractor, router: MovieDetailRouter = MovieDetailRouter()) {
        self.movieID = movieID
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor func fetchDetail() async {
        movie = nil
        movieError = nil
        
        do {
            let fetchedMovie = try await interactor.fetchDetail(movieID: movieID)
            movie = fetchedMovie
            reviews = fetchedMovie.userReviews
            
        } catch (let error) {
            movieError = error
        }
    }
    
    @MainActor func fetchMoreReviews() async {
        do {
            let fetchedReviews = try await interactor.fetchMoreReviews(movieID: movieID, page: page)
            page += 1
            isMaxItem = (page > maximumPage || fetchedReviews.isEmpty)
            
            if !fetchedReviews.isEmpty {
                reviews.append(contentsOf: fetchedReviews)
            }
            
        } catch (let error) {
            // TODO: - handle error with better design.
            print(error.localizedDescription)
        }
    }
    
    func opernTrailer(url: URL) -> SafariView {
        router.makeSafariView(url: url)
    }
}
