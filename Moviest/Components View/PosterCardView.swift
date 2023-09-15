//
//  PosterCardView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import SwiftUI

struct PosterCardView: View {
    
    let movie: Movie
    
    @State var isShowRate: Bool = true
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                makeImageCardView(uiImage: image)
            } else {
                placeholderView
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .cornerRadius(4)
        .shadow(radius: 4)
        .task {
            if let posterURL = movie.posterURL {
                imageLoader.loadImage(from: posterURL)
            }
        }
    }
    
    var placeholderView: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.2))
            
            VStack(spacing: 20) {
                ProgressView()
                Text(movie.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    func makeImageCardView(uiImage: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
            
            if isShowRate {
                RateView(rate: movie.rateText)
            }
        }
    }
}

struct PosterCardView_Previews: PreviewProvider {
    static var previews: some View {
        return PosterCardView(movie: Movie.stubbedMovie)
    }
}
