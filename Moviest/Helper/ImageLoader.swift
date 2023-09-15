//
//  ImageLoader.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import Foundation
import UIKit

let _cache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    
    private let imageCache = _cache
    @Published var image: UIImage? = nil
    
    @MainActor func loadImage(from url: URL) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage  {
            image = cachedImage
            return
        }
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            guard let data = try? Data(contentsOf: url), let fetchedImage = UIImage(data: data) else {
                return
            }
            
            imageCache.setObject(fetchedImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }
    }
}
