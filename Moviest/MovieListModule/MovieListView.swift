//
//  MovieListView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import SwiftUI

struct MovieListView: View {
    
    @StateObject var presenter: MovieListPresenter
    @State private var viewDidLoad = false
    
    private let items: [GridItem] = [GridItem(spacing: 10), GridItem(spacing: 10)]
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                if presenter.isFetching {
                    ProgressView()
                    
                } else if let movies = presenter.movies {
                    makeMoviesGridView(movies: movies)
                    
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .refreshable {
                Task {
                    await presenter.fetchMovies()
                }
            }
            
            if let error = presenter.moviesError {
                ErrorView(errorMessage: error.localizedDescription) {
                    Task {
                        await presenter.fetchMovies()
                    }
                }
            }
        }
        .navigationTitle(presenter.genreName)
        .task {
            if !viewDidLoad {
                viewDidLoad = true
                await presenter.fetchMovies()
            }
        }
    }
    
    private func makeMoviesGridView(movies: [Movie]) -> some View {
        LazyVGrid(columns: items, alignment: .center, spacing: 8) {
            ForEach(movies) { movie in
                VStack {
                    NavigationLink {
                        presenter.presentMovieDetailView(id: movie.id)
                    } label: {
                        VStack {
                            PosterCardView(movie: movie, isShowRate: true)
                            Text(movie.title)
                                .ignoresSafeArea(edges: .top)
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .bold()
                        }
                    }
                    Spacer()
                }
            }
            
            if !presenter.isMaxItem {
                if presenter.isFetchingMore {
                    ProgressView()
                } else {
                    Text("load more...")
                        .bold()
                        .onAppear {
                            Task {
                                await presenter.fetchMore()
                            }
                        }
                }
            }
        }
        .padding()
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(genre: Genre(id: 28, name: "Action"), interactor: interactor)
        let view = MovieListView(presenter: presenter)
        return NavigationView {
            view
        }
    }
}
