//
//  DataAction.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

protocol DataAction {
    associatedtype ResponseObject

    func perform(_ completion: @escaping (Result<ResponseObject, Error>) -> Void)
}




