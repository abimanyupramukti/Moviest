//
//  Review.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 14/09/23.
//

import Foundation

struct ReviewResponse: Codable {
    let results: [Review]
}

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: Author
    let content: String
    let updatedAt: String
    
    var formattedDate: String {
        guard let date =  Utils.reviewDateFormatter.date(from: updatedAt) else {
            return "-"
        }
        return Utils.standardDateFormatter.string(from: date)
    }
    
    var formattedRating: String? {
        guard let rating = authorDetails.rating else { return nil }
        let number = NSNumber(value: rating)
        return Utils.numberFormatter.string(from: number)
    }
}


struct Author: Codable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
}
