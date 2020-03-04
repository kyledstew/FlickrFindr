//
//  FlickrImage.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct FlickrImage: Equatable {
    var id: String
    var title: String
    var thumbnailImageURL: URL?
    var imageURL: URL?
}

extension FlickrImage {
    init(photo: FlickrAPI.Photo) {
        self.id = photo.id
        self.title = photo.title
        self.thumbnailImageURL = photo.thumbnailURL
        self.imageURL = photo.fullImageURL
    }
}
