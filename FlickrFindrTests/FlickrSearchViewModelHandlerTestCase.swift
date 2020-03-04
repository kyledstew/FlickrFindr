//
//  FlickrFindrTests.swift
//  FlickrFindrTests
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import XCTest
@testable import FlickrFindr

class FlickrSearchViewModelHandlerTestCase: XCTestCase {
    typealias Handler = FlickrSearchViewModel.Handler
    typealias State = FlickrSearchViewModel.State

    func testStateReset() {
        let state = State()
        state.isLoading = true
        state.addRecentSearchKeywordDataAction = AddRecentSearchKeyword(keyword: "keyword")
        state.searchFlickrDataAction = SearchFlickr(config: .init(keyword: "keyword"))
        state.loadRecentSearchKeywordsDataAction = LoadRecentSearchKeywords()

        state.reset()

        XCTAssertFalse(state.isLoading)
        XCTAssertNil(state.addRecentSearchKeywordDataAction)
        XCTAssertNil(state.searchFlickrDataAction)
        XCTAssertNil(state.loadRecentSearchKeywordsDataAction)
    }

    func testIsEnteringTextEvent() {
        let handler = Handler()
        let state = State()
        state.recentSearchKeywords = ["test"]

        handler.handle(event: .isEnteringText(true), state: state)
        XCTAssert(state.showRecentKeywords)

        handler.handle(event: .isEnteringText(false), state: state)
        XCTAssertFalse(state.showRecentKeywords)
    }

    func testSearchSelected() {
        let handler = Handler()
        let state = State()
        state.flickrImages = TestData.testImages

        let keyword: String = "Search Test"

        handler.handle(event: .searchSelected(keyword),
                       state: state)

        checkStateAfterSearch(state: state, keyword: keyword)
    }

    func testRecentKeywordSelected() {
        let handler = Handler()
        let state = State()
        state.flickrImages = TestData.testImages

        let keyword: String = "Select Test"

        handler.handle(event: .recentKeywordSelected(keyword),
                       state: state)

        checkStateAfterSearch(state: state, keyword: keyword)
    }

    func checkStateAfterSearch(state: State, keyword: String) {
        XCTAssert(state.isLoading)
        XCTAssert(state.flickrImages.isEmpty)
        XCTAssert(state.recentSearchKeywords.contains(keyword))
        XCTAssertEqual(state.addRecentSearchKeywordDataAction?.keyword, keyword)

        let config = SearchFlickr.Config(keyword: keyword)
        XCTAssertEqual(state.searchFlickrDataAction?.config, config)
        XCTAssertEqual(state.searchFlickrConfig, config)
    }

    func testCancelSearchSelected() {
        let handler = Handler()
        let state = State()
        state.showRecentKeywords = true

        handler.handle(event: .searchCancel, state: state)

        XCTAssertFalse(state.showRecentKeywords)
    }

    func testImagesLoaded() {
        let handler = Handler()
        let state = State()

        let testImages = TestData.testImages

        handler.handle(event: .imagesLoaded(testImages), state: state)

        XCTAssertEqual(state.flickrImages, testImages)
    }

    func testLoadMoreImagesSelected() {
        let handler = Handler()
        let state = State()
        var newConfig = SearchFlickr.Config(keyword: "Keyword")

        state.searchFlickrConfig = newConfig

        handler.handle(event: .loadMoreImagesSelected, state: state)

        newConfig.incrementPage()

        XCTAssert(state.isLoading)
        XCTAssertEqual(state.searchFlickrConfig?.page, 2)
        XCTAssertEqual(state.searchFlickrDataAction?.config, newConfig)
    }

    func testRecentSearchKeywordsLoadedEvent() {
        let handler = Handler()
        let state = State()

        let testSearchKeywords = TestData.testSearchKeywords

        handler.handle(event: .recentSearchKeywordsLoaded(testSearchKeywords), state: state)

        XCTAssertEqual(state.recentSearchKeywords, testSearchKeywords.reversed())
    }

    func testFlickrImageSelected() {
        let handler = Handler()
        let state = State()

        let image = TestData.testImages[0]

        handler.handle(event: .flickrImageSelected(image),
                       state: state)

        XCTAssertEqual(state.selectedImageURL, image.imageURL)
        XCTAssert(state.focusOnSelectedImage)
        XCTAssertEqual(state.focusedImageTitle, image.title)
    }

    func testDismissOverlayImage() {
        let handler = Handler()
        let state = State()

        let image = TestData.testImages[0]

        state.selectedImageURL = image.imageURL
        state.focusOnSelectedImage = true
        state.focusedImageTitle = image.title

        handler.handle(event: .dismissOverlayImage,
                       state: state)

        XCTAssertNil(state.selectedImageURL)
        XCTAssertFalse(state.focusOnSelectedImage)
        XCTAssertNil(state.focusedImageTitle)
    }
}

