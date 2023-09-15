//
//  Extensions.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 15/09/23.
//

import Foundation

extension Bundle {
    var movieServiceAPIKey: String {
        return object(forInfoDictionaryKey: "TMDb API Key") as? String ?? ""
    }
    
    func loadAndDecodeJSON<T: Decodable>(filename: String) -> T? {
        guard let url = url(forResource: filename, withExtension: "json"), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? Utils.decodeer.decode(T.self, from: data)
    }
}
