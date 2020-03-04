//
//  UserDefaults.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

struct FlickrFindrUserDefaults {

    fileprivate static var recentKeywordsUserDefaultsKey = "FlickrFinder.recentKeywordsUserDefaultsKey"

    static var recentKeywords: [String] {
        get {
            UserDefaults.standard.value(forKey: recentKeywordsUserDefaultsKey) as? [String] ?? []
        }

        set {
            UserDefaults.standard.set(newValue, forKey: recentKeywordsUserDefaultsKey)
        }
    }
    
}
