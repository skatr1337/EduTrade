//
//  ImageCache.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import SwiftUI

protocol ImageCacheProtocol {
    func get(url: URL) -> Image?
    func set(url: URL, image: Image)
}

class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()

    private let lockQueue = DispatchQueue(
        label: "imageCache.lock.queue",
        attributes: .concurrent
    )
    private var images: [URL: Image] = [:]

    private init() {
        // Don't allow multiple instances
    }

    func get(url: URL) -> Image? {
        lockQueue.sync {
            images[url]
        }
    }

    func set(url: URL, image: Image) {
        lockQueue.async(flags: .barrier) { [weak self] in
            self?.images[url] = image
        }
    }

    func remove(url: URL) {
        lockQueue.async(flags: .barrier) { [weak self] in
            self?.images.removeValue(forKey: url)
        }
    }
}
