//
//  ImageCacher.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import SwiftUI

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageCacher: ObservableObject {
    enum Error: Swift.Error {
        case unknownError
    }

    @Published var isLoading: Bool = false
    @Published var image: Image?

    var task: URLSessionTask?

    init(url: URL? = nil) {
        if let url = url {
            loadImage(url: url)
        }
    }

    func loadImage(url: URL) {
        if let image = loadImageFromCache(url: url) {
            self.isLoading = false
            self.setImage(image: image)
        } else {
            self.isLoading = true
            downloadImage(url: url) { result in
                switch result {
                case let .success(image):
                    self.addImageToCache(image: image, url: url)
                    self.setImage(image: Image(uiImage: image))

                case let .failure(error):
                    print("Error loading image: \(error)")
                    self.setImage(image: Image(systemName: "photo"))
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
    }

    private func setImage(image: Image) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.image = image
        }
    }

    /// Returns image with given url from cache
    private func loadImageFromCache(url: URL) -> Image? {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return Image(uiImage: image)
        } else {
            return nil
        }
    }

    /// Add image to cache
    private func addImageToCache(image: UIImage, url: URL) {
        imageCache.setObject(image, forKey: url as AnyObject)
    }

    /// Download and caches image at given URL
    private func downloadImage(url: URL, completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(error ?? Error.unknownError))
                }
            })

            self.task?.resume()
        }
    }
}
