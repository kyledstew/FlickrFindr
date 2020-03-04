//
//  LoadRecentSearchKeywords.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/2/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct LoadRecentSearchKeywords: DataAction {
    func perform(_ completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(FlickrFindrUserDefaults.recentKeywords))
    }
}
