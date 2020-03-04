//
//  FlickrSearchViewModel.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import Foundation

class FlickrSearchViewModel {
    var state: State
    var handler: Handler

    init() {
        state = State()
        handler = Handler()
    }
}

// MARK: - Objects used by ViewModel
extension FlickrSearchViewModel {
    enum Event {
        case loadRecentKeywords
        case isEnteringText(Bool)
        case searchSelected(String)
        case searchCancel
        case recentKeywordSelected(String)
        case imagesLoaded([FlickrImage])
        case loadMoreImagesSelected
        case recentSearchKeywordsLoaded([String])
        case flickrImageSelected(FlickrImage)
        case dismissOverlayImage
        case error(Error)
    }

    class State: ObservableObject {

        // Published Objects
        @Published var showRecentKeywords: Bool = false
        @Published var isLoading: Bool = false
        @Published var flickrImages: [FlickrImage] = []
        @Published var recentSearchKeywords: [String] = []
        @Published var focusOnSelectedImage: Bool = false
        @Published var selectedImageURL: URL?

        // Other Objects
        var searchFlickrConfig: SearchFlickr.Config?
        var focusedImageTitle: String?
        var imageCacher = ImageCacher()

        // DataActions
        var addRecentSearchKeywordDataAction: AddRecentSearchKeyword?
        var searchFlickrDataAction: SearchFlickr?
        var loadRecentSearchKeywordsDataAction: LoadRecentSearchKeywords?

        // Functions

        func reset() {
            isLoading = false
            addRecentSearchKeywordDataAction = nil
            searchFlickrDataAction = nil
            loadRecentSearchKeywordsDataAction = nil
        }

    }

    /// Handle events and update state accordingly
    struct Handler: FlickrFindr.Handler {
        func handle(event: Event, state: State) {
            state.reset()

            switch event {
            case .loadRecentKeywords:
                state.loadRecentSearchKeywordsDataAction = LoadRecentSearchKeywords()

            case let .isEnteringText(value):
                if value && !state.recentSearchKeywords.isEmpty {
                    state.showRecentKeywords = true
                } else {
                    state.showRecentKeywords = false
                }

            case let .searchSelected(value),
                 let .recentKeywordSelected(value):
                if !value.isEmpty {
                    state.isLoading = true
                    state.flickrImages.removeAll()
                    state.recentSearchKeywords.append(value)
                    state.addRecentSearchKeywordDataAction = AddRecentSearchKeyword(keyword: value)
                    let config = SearchFlickr.Config(keyword: value)
                    state.searchFlickrDataAction = SearchFlickr(config: config)
                    state.searchFlickrConfig = config
                }

            case .searchCancel:
                state.showRecentKeywords = false

            case let .imagesLoaded(flickrImages):
                state.flickrImages.append(contentsOf: flickrImages)

            case .loadMoreImagesSelected:
                guard var config = state.searchFlickrConfig else {
                    break
                }

                state.isLoading = true
                config.incrementPage()
                state.searchFlickrDataAction = SearchFlickr(config: config)
                state.searchFlickrConfig = config

            case let .recentSearchKeywordsLoaded(keywords):
                state.recentSearchKeywords = keywords.reversed()

            case let .flickrImageSelected(image):
                if let url = image.imageURL {
                    state.imageCacher.loadImage(url: url)
                }
                state.selectedImageURL = image.imageURL
                state.focusOnSelectedImage = true
                state.focusedImageTitle = image.title

            case .dismissOverlayImage:
                state.selectedImageURL = nil
                state.focusOnSelectedImage = false
                state.focusedImageTitle = nil
                state.imageCacher.image = nil

            case let .error(error):
                print(error)

            }
        }
    }
}

// MARK: - Conform to `ViewModel`
extension FlickrSearchViewModel: ViewModel {
    func notify(event: FlickrSearchViewModel.Event) {
        handler.handle(event: event, state: state)

        handle(state.searchFlickrDataAction)
        handle(state.loadRecentSearchKeywordsDataAction)
        handle(state.addRecentSearchKeywordDataAction)
    }

    func handle<T: DataAction>(_ dataAction: T?) {
        guard let action = dataAction else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            action.perform(self.handle)
        }
    }

    func handle<T>(_ result: Result<T, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .success(flickrImages as [FlickrImage]):
                self.notify(event: .imagesLoaded(flickrImages))

            case let .success(keywords as [String]):
                self.notify(event: .recentSearchKeywordsLoaded(keywords))

            case let .failure(error):
                self.notify(event: .error(error))

            default: break
            }
        }
    }
}

