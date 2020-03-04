//
//  FlickrAPI.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/28/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct FlickrAPI {
    enum Error: Swift.Error {
        case unknownError
    }

    enum NetworkConstants {
        static let host: String = "https://api.flickr.com/services/rest/"
        static let apiKey: String = "1508443e49213ff84d566777dc211f2a"
        static let resultsPerPage: Int = 25
    }

    static func search(withKeyword keyword: String,
                       perPage: Int = NetworkConstants.resultsPerPage,
                       page: Int = 1,
                       completion: @escaping (Result<PhotosResponse, Swift.Error>) -> Void) {
        let parameters: [String: Any] = [
            "method": "flickr.photos.search",
            "api_key": NetworkConstants.apiKey,
            "text": keyword,
            "format": "json",
            "nojsoncallback": 1,
            "per_page": perPage,
            "page": page
        ]
        
        let host: URL = URL(string: NetworkConstants.host)!
        let request = URLRequest(url: host.attachingParameters(parameters))

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(Error.unknownError))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                completion(.success(response.photos))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
