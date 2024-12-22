//
//  ImageCache.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import SwiftUI

public protocol ImageCacheProtocol {
    func get(url: URL) -> Image?
    func set(url: URL, image: Image)
}

public class ImageCache: ImageCacheProtocol {
    public static let shared = ImageCache()

    private var images: [URL: Image] = [:]

    private init() {
        // Don't allow multiple instances
    }

    public func get(url: URL) -> Image? {
        images[url]
    }

    public func set(url: URL, image: Image) {
        images[url] = image
    }

    public func clear() {
        images.removeAll()
    }
}
