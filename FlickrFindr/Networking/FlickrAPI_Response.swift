//
//  FlickrAPI_Response.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/3/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

extension FlickrAPI {
    struct Response: Codable {
        var photos: PhotosResponse
    }

    struct PhotosResponse: Codable {
        var page: Int
        var pages: Int
        var perpage: Int
        var photo: [Photo]
    }

    struct Photo: Codable {
        var id: String
        var title: String
        var secret: String
        var server: String
        var farm: Int

        var thumbnailURL: URL? {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_t.jpg")
        }

        var fullImageURL: URL? {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg")
        }
    }
}
