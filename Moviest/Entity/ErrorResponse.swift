//
//  Error.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 17/09/23.
//

import Foundation

struct ErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
}
