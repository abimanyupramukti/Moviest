//
//  Genre.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
