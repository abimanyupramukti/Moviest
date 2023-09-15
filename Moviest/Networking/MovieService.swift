//
//  APIService.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import Foundation

enum MovieListEndPoint: String {
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming
    case popular
}

enum MovieError: Error, CustomNSError {
    case invalidEndpoint
    case invalidResponse(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .invalidResponse(let message):
            return message
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

protocol MovieServiceable {
    
}

final class MovieService {
    
    private let apiKey = Bundle.main.movieServiceAPIKey
    private let baseURLString = "https://api.themoviedb.org/3/"
    
    private let session =  URLSession.shared
    private let decoder = Utils.decodeer
    
    private var urlComponents: URLComponents {
        var components = URLComponents(string: baseURLString)!
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        return components
    }
    
    func fetchMovies(endPoint: MovieListEndPoint) async throws -> MovieResponse {
        return try await loadDataAndDecode(path: "/movie/\(endPoint.rawValue)")
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        let params = [
            "append_to_response": "videos,reviews"
        ]
        return try await loadDataAndDecode(path: "/movie/\(id)", params: params)
    }
    
    func fetchGenres() async throws -> GenreResponse {
        return try await loadDataAndDecode(path: "/genre/movie/list")
    }
    
    func fetchReviews(movieID: Int, page: Int) async throws -> ReviewResponse {
        let params = [
            "page": "\(page)"
        ]
        return try await loadDataAndDecode(path: "movie/\(movieID)/reviews", params: params)
    }
    
    func searchMovie(title: String) async throws -> MovieResponse {
        let params = [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": title
        ]
        
        return try await loadDataAndDecode(path: "/search/movie", params: params)
    }
    
    func searchMovie(genreID: Int, page: Int = 1) async throws -> MovieResponse {
        let params = [
            "page" : "\(page)",
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "with_genres": "\(genreID)"
        ]
        
        return try await loadDataAndDecode(path: "/discover/movie", params: params)
    }
    
    private func loadDataAndDecode<T: Decodable>(path: String, params: [String: String]? = nil) async throws -> T {
        
        var components = URLComponents(string: baseURLString)
        components?.path += path
        components?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let params = params {
            components?.queryItems?.append(contentsOf: params.map { URLQueryItem(name: $0, value: $1) })
        }
        
        guard let url = components?.url else {
            throw MovieError.invalidEndpoint
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let error = try decoder.decode(ErrorResponse.self, from: data)
            throw MovieError.invalidResponse(message: error.statusMessage)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
