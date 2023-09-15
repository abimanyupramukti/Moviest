//
//  Movie.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let backdropPath: String?
    let posterPath: String?
    
    var genres: [Genre]?
    
    var videos: VideoResponse?
    var reviews: ReviewResponse?
    
    var assetBaseURLString: String {
        "https://image.tmdb.org/t/p/w500"
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: assetBaseURLString + path)
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: assetBaseURLString + path)
    }
    
    var rateText: String {
        let rate = NSNumber(value: voteAverage)
        return Utils.numberFormatter.string(from: rate) ?? "0"
    }
    
    var formattedDate: String {
        guard let date =  Utils.movieDateFormatter.date(from: releaseDate) else {
            return "-"
        }
        return Utils.standardDateFormatter.string(from: date)
    }
    
    var trailers: [Video] {
        return videos?.results.filter { $0.type == "Trailer" } ?? []
    }
    
    var userReviews: [Review] {
        reviews?.results ?? []
    }
}
