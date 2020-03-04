//
//  SearchFlickr.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/2/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct SearchFlickr: DataAction {
    struct Config: Equatable {
        var keyword: String
        var page: Int

        init(keyword: String) {
            self.keyword = keyword
            self.page = 1
        }

        mutating func incrementPage() {
            page += 1
        }
    }

    var config: Config

    init(config: Config) {
        self.config = config
    }

    func perform(_ completion: @escaping (Result<[FlickrImage], Error>) -> Void) {
        FlickrAPI.search(withKeyword: config.keyword, page: config.page) { result in
            switch result {
            case let .success(response):
                let convertedImages = response.photo.map { FlickrImage(photo: $0) }
                completion(.success(convertedImages))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
