//
//  TestData.swift
//  FlickrFindrTests
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

@testable import FlickrFindr

struct TestData {
    static let testImages: [FlickrImage] = [
        FlickrImage(id: "1", title: "Test Title 1", thumbnailImageURL: nil, imageURL: nil),
        FlickrImage(id: "2", title: "Test Title 2", thumbnailImageURL: nil, imageURL: nil),
        FlickrImage(id: "3", title: "Test Title 3", thumbnailImageURL: nil, imageURL: nil),
        FlickrImage(id: "4", title: "Test Title 4", thumbnailImageURL: nil, imageURL: nil),
    ]

    static let testSearchKeywords: [String] = [
        "Food", "Football", "Soccer", "Travel"
    ]
}
