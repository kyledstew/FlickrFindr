//
//  FlickrImageDetailView.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import SwiftUI

struct FlickrImageDetailView: View {
    var flickrImage: FlickrImage

    @ObservedObject private var imageCacher: ImageCacher

    init(flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        imageCacher = ImageCacher(url: flickrImage.thumbnailImageURL)
    }

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ZStack {
                    (imageCacher.image ?? Image(systemName: "photo"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)

                    ActivityIndicator(isAnimating: $imageCacher.isLoading, style: .large)
                }

                Spacer()

                VStack {
                    Text(self.flickrImage.title)
                        .font(.body)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                }
            }
        }
    }
}
