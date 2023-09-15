//
//  GenreListView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

struct GenreListView: View {
    
    @StateObject var presenter: GenreListPresenter
    @State private var viewDidLoad = false
    
    var body: some View {
        ZStack {
            List {
                if let genres = presenter.genres {
                    ForEach(genres) { genre in
                        NavigationLink {
                            presenter.presentMovieListView(genre: genre)
                        } label: {
                            Text(genre.name)
                        }
                    }
                }
            }
            
            if let error = presenter.genresError {
                ErrorView(errorMessage: error.localizedDescription)
            }
        }
        .task {
            if !viewDidLoad {
                viewDidLoad = true
                await presenter.fetchGenres()
            }
        }
    }
}

struct GenreListView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = GenreListInteractor()
        let presenter = GenreListPresenter(interactor: interactor)
        let view = GenreListView(presenter: presenter)
        return view
    }
}
