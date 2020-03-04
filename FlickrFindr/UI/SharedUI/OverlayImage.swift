//
//  OverlayImage.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 3/2/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import SwiftUI

struct OverlayImage: View {
    @Binding var imageURL: URL?

    @ObservedObject var imageCacher: ImageCacher

    var onDismissOverlayImageAction: () -> Void

    var body: some View {
        ZStack {
            BlurView(style: .systemMaterial)
                .frame(minHeight: 0, maxHeight: .infinity)

            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        self.onDismissOverlayImageAction()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.secondary)
                    })
                }
                .padding()

                Spacer()

                (imageCacher.image ?? Image(systemName: "photo"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Spacer()
            }

            ActivityIndicator(isAnimating: $imageCacher.isLoading, style: .large)
        }
    }
}
