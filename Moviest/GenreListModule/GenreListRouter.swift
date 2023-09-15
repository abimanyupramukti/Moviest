//
//  GenreListRouter.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

class GenreListRouter {
    func makeMovieListView(for genre: Genre) -> some View {
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(genre: genre, interactor: interactor)
        return MovieListView(presenter: presenter)
    }
}
