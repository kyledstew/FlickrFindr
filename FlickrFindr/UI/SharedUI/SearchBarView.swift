//
//  SearchView.swift
//  FlickrFindr
//
//  Created by Kyle Stewart on 2/27/20.
//  Copyright © 2020 Kyle Stewart. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {

    @State private var searchText: String = ""
    @State private var isEditing: Bool = false

    var onEditingChangedAction: ((Bool) -> Void)? = nil
    var onCommitAction: (String) -> Void
    var onCancelAction: () -> Void

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search",
                          text: self.$searchText,
                          onEditingChanged: onEditingChanged,
                          onCommit: self.onCommit)
                    .foregroundColor(Color.primary)

                Button(action: clearSelected, label: {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchText == "" ? 0 : 1)
                        .animation(.none)
                })

            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)

            if isEditing {
                Button(action: cancelSelected, label: {
                    Text("Cancel")
                })
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .animation(.easeIn)
    }

    // MARK: - Action Functions

    private func onEditingChanged(value: Bool) {
        isEditing = value
        onEditingChangedAction?(value)
    }

    private func onCommit() {
        onCommitAction(searchText)
        searchText = ""
    }

    private func cancelSelected() {
        endEditing()
        onCancelAction()
    }

    private func clearSelected() {
        searchText = ""
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBarView(onEditingChangedAction: { (isEditing) in
                print("isEditing")
            }, onCommitAction: { value in
                print(value)
            }, onCancelAction: {})

            Spacer()
        }
        .padding()
    }
}
