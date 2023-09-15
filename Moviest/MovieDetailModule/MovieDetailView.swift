//
//  MovieDetailView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject private var imageLoader = ImageLoader()
    @StateObject var presenter: MovieDetailPresenter
    
    @State private var viewDidLoad = false
    
    var body: some View {
        ZStack {
            ScrollView {
                if let movie = presenter.movie {
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        makeDetailView(movie: movie)
                        
                        makeOverviewSection(overview: movie.overview)
                        
                        if !movie.trailers.isEmpty {
                            makeTrailerSection(trailers: movie.trailers)
                        }
                        
                        if !presenter.reviews.isEmpty {
                            makeReviewSection(reviews: presenter.reviews)
                        }
                    }
                    .padding()
                }
            }
            
            if let error = presenter.movieError {
                ErrorView(errorMessage: error.localizedDescription) {
                    Task {
                        await presenter.fetchDetail()
                    }
                }
                
            }
        }
        .navigationTitle("Detail")
        .task {
            if !viewDidLoad {
                viewDidLoad = true
                await presenter.fetchDetail()
            }
        }
    }
    
    private func makeDetailView(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(movie.title)
                .foregroundColor(.primary)
                .font(.title)
                .bold()
            
            HStack(spacing: 8) {
                if let genres = movie.genres {
                    ForEach(genres) { genre in
                        Text(genre.name)
                            .font(.caption)
                            .bold()
                        
                        if genre != genres.last {
                            Divider()
                                .frame(width: 2)
                                .overlay(.gray.opacity(0.4))
                        }
                    }
                }
            }
            
            Text("Rate: \(movie.rateText) / 10 ⭐️")
            
            Text("Release Date: \(movie.formattedDate)")
        }
        .task {
            if let backdropURL = presenter.movie?.backdropURL {
                imageLoader.loadImage(from: backdropURL)
            }
        }
    }
    
    private func makeOverviewSection(overview: String) -> some View {
        sectionBuilder(title: "Overview") {
            Text(overview)
        }
    }
    
    private func makeTrailerSection(trailers: [Video]) -> some View {
        sectionBuilder(title: "Trailers") {
            ForEach(trailers) { trailer in
                Button {
                    presenter.selectedTrailer = trailer
                } label: {
                    HStack {
                        Text(trailer.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                .sheet(item: $presenter.selectedTrailer) { trailer in
                    if let url = trailer.youtubeURL {
                        presenter.opernTrailer(url: url)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    private func makeReviewSection(reviews: [Review]) -> some View {
        sectionBuilder(title: "Reviews") {
            LazyVStack {
                ForEach(reviews) { review in
                    makeReviewView(review: review)
                }
                
                if !presenter.isMaxItem {
                    Button {
                        Task {
                            await presenter.fetchMoreReviews()
                        }
                    } label: {
                        Text("load more")
                            .bold()
                    }
                }
            }
        }
    }
    
    private func makeReviewView(review: Review) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(review.author)
                    .bold()
                
                if let rating = review.formattedRating {
                    Text("\(rating) ★")
                        .shadow(radius: 8)
                        .font(.subheadline)
                        .padding([.leading, .trailing], 2)
                        .bold()
                        .foregroundColor(.primary)
                        .background {
                            Rectangle()
                                .fill(.yellow)
                                .cornerRadius(4)
                        }
                }
                
                Text(review.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            let reviewIndex = presenter.expandedReviews.firstIndex(where: { $0.id == review.id })
            
            Text(review.content)
                .lineLimit(reviewIndex != nil ? nil : 2)
            
            Text(reviewIndex != nil ? "show less..." : "show more...")
            
                .foregroundColor(.accentColor)
                .onTapGesture {
                    if let index = reviewIndex {
                        presenter.expandedReviews.remove(at: index)
                    } else {
                        presenter.expandedReviews.append(review)
                    }
                }
            
            Divider()
        }
    }
    
    private func sectionBuilder<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        Section {
            content()
        } header: {
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                
                Text(title)
                    .font(.title3)
                    .bold()
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter(movieID: Movie.stubbedMovie.id, interactor: interactor)
        let view = MovieDetailView(presenter: presenter)
        return NavigationView {
            view
        }
    }
}
