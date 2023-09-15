//
//  MovieListRouter.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

class MovieListRouter {
    func makeMovieDetailView(for id: Int) -> some View {
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter(movieID: id, interactor: interactor)
        return MovieDetailView(presenter: presenter)
    }
}
