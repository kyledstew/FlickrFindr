//
//  ViewModel.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype StateType
    associatedtype EventType

    var state: StateType { get set }

    func notify(event: EventType)
}
