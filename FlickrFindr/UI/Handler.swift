//
//  Handler.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

protocol Handler {
    associatedtype StateType
    associatedtype EventType

    func handle(event: EventType, state: StateType)
}
