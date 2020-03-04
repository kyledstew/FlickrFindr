//
//  AddRecentSearchKeyword.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/2/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct AddRecentSearchKeyword: DataAction {
    var keyword: String

    func perform(_ completion: @escaping (Result<[String], Error>) -> Void) {
        var recentKeywords = FlickrFindrUserDefaults.recentKeywords
        recentKeywords.removeAll(where: { $0 == keyword })
        recentKeywords.append(keyword)
        FlickrFindrUserDefaults.recentKeywords = recentKeywords

        return completion(.success(FlickrFindrUserDefaults.recentKeywords))
    }
}
