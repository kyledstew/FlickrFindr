//
//  FlickrSearchView.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/26/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import SwiftUI

struct FlickrSearchView: View {
    var viewModel: FlickrSearchViewModel

    @ObservedObject var state: FlickrSearchViewModel.State

    init() {
        viewModel = FlickrSearchViewModel()
        state = viewModel.state
    }

    enum Layout {
        static var searchBarHeight: CGFloat = 50
        static var recentKeywordsListHeight: CGFloat = 300
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    searchBarView()
                    
                    resultsList()
                }

                VStack {
                    recentKeywordsList()

                    Spacer()
                }
                .padding(.top, Layout.searchBarHeight)
                .shadow(radius: 10)

                ActivityIndicator(isAnimating: self.$state.isLoading, style: .large)
            }
            .overlay(overlayImage())
            .navigationBarTitle(state.focusedImageTitle ?? state.searchFlickrConfig?.keyword.uppercased() ?? "SEARCH")
        }
        .onAppear {
            self.viewModel.notify(event: .loadRecentKeywords)
        }
    }
}

// MARK: - Views

extension FlickrSearchView {
    // Search Bar View
    func searchBarView() -> some View {
        SearchBarView(onEditingChangedAction: searchBarEditingChanged,
                      onCommitAction: searchBarOnCommit,
                      onCancelAction: searchCancelAction)
            .frame(height: Layout.searchBarHeight)
    }

    // List with results of search
    func resultsList() -> some View {
        List {
            Section(footer: Button(action: loadMoreSelected,
                                   label: {
                                    Button(action: loadMoreSelected) {
                                        Text("Load More Results")
                                            .frame(height: 50)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    }}),
                    content: {
                        ForEach(self.state.flickrImages, id: \.id) { flickrImage in
                            FlickrImageDetailView(flickrImage: flickrImage)
                                .onTapGesture {
                                    self.viewModel.notify(event: .flickrImageSelected(flickrImage))
                            }
                        }})
        }
        .opacity(self.state.flickrImages.isEmpty ? 0 : 1)

    }

    // List of recent search keywords
    func recentKeywordsList() -> some View {
        List(self.state.recentSearchKeywords, id: \.self) { value in
            HStack {
                Text(value)

                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .onTapGesture { self.recentKeywordSelected(value) }
        }
        .frame(minHeight: 0, maxHeight: state.showRecentKeywords ? Layout.recentKeywordsListHeight : 0)
        .cornerRadius(10)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .animation(.default)
    }

    // Overlay Image showing currently selected Image
    func overlayImage() -> some View {
        OverlayImage(imageURL: $state.selectedImageURL,
                     imageCacher: state.imageCacher,
                     onDismissOverlayImageAction: dismissOverlayImage)
            .opacity(state.focusOnSelectedImage ? 1 : 0)
            .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Action Functions

extension FlickrSearchView {
    private func searchBarEditingChanged(_ value: Bool) {
        viewModel.notify(event: .isEnteringText(value))
    }

    private func searchBarOnCommit(_ value: String) {
        viewModel.notify(event: .searchSelected(value))
    }

    private func searchCancelAction() {
        viewModel.notify(event: .searchCancel)
    }

    private func recentKeywordSelected(_ value: String) {
        viewModel.notify(event: .recentKeywordSelected(value))
        endEditing()
    }

    private func loadMoreSelected() {
        viewModel.notify(event: .loadMoreImagesSelected)
    }

    private func dismissOverlayImage() {
        viewModel.notify(event: .dismissOverlayImage)
    }
}

// MARK: - Previews
struct FlickrSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FlickrSearchView()
    }
}
