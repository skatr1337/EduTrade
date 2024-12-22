//
//  AsyncImageCached.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import SwiftUI

public struct AsyncImageCached<Content>: View where Content: View {
    private let url: URL
    @ViewBuilder
    private let content: (AsyncImagePhase) -> Content
    private let imageCache: ImageCacheProtocol

    public init(
        url: URL,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content,
        imageCache: ImageCacheProtocol = ImageCache.shared
    ) {
        self.url = url
        self.content = content
        self.imageCache = imageCache
    }

    public var body: some View {
        if let image = imageCache.get(url: url) {
            content(.success(image))
        } else {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    content(phase).task {
                        imageCache.set(url: url, image: image)
                    }
                } else {
                    content(phase)
                }
            }
        }
    }
}

#Preview {
    guard let url = URL(
        string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    ) else {
        return EmptyView()
    }

    return AsyncImageCached(url: url) { phase in
        if let image = phase.image {
            ZStack {
                image
                    .resizable()
            }
        } else if phase.error != nil {
            ZStack {
                Rectangle()
                    .fill(.red)
                VStack {
                    Text("Loading error...")
                }
            }
        } else {
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                VStack {
                    Text("Loading...")
                }
            }
        }
    }
    .cornerRadius(12)
    .frame(height: 140)
}
