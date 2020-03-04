//
//  URL.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/3/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

extension URL {
    func attachingParameters(_ parameters: [String: Any]) -> URL {
        guard !parameters.isEmpty else { return self}
        let path = self.absoluteString + "?" + parameters.compactMap { "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)" }.joined(separator: "&")
        return URL(string: path)!
    }
}
