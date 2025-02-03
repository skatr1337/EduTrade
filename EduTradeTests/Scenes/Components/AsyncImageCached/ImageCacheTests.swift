//
//  ImageCacheTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 28.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SwiftUI

struct ImageCacheTests {
    let imageCache: ImageCache

    init() {
        imageCache = ImageCache.shared
    }
    
    @Test(
        "Test not exisisting image",
        arguments: zip(
            [
                "https://image.com/image_not_existing.png",
                "https://imageNotExisting.com/image_other_not_existing.png"
            ] as [String],
            [
                nil,
                nil
            ] as [Image?]
        )
    )
    func notExisistingImage(urlString: String, resultURL: Image?) throws {
        // Given
        guard let url = URL(string: urlString) else {
            throw ImageCacheError.urlNotValid
        }
        imageCache.remove(url: url)

        // When / Then
        #expect(imageCache.get(url: url) == resultURL)
    }

    @Test(
        "Test exisisting image",
        arguments: zip(
            [
                "https://image.com/image_existing.png",
                "https://image.com/image_other_existing.png"
            ] as [String],
            [
                Image(systemName: "house"),
                Image(systemName: "person")
            ] as [Image]
        )
    )
    func exisistingImage(urlString: String, image: Image) throws {
        // Given
        guard let url = URL(string: urlString) else {
            throw ImageCacheError.urlNotValid
        }
        imageCache.remove(url: url)

        // When
        imageCache.set(url: url, image: image)

        // Then
        #expect(imageCache.get(url: url) == image)
    }

    @Test(
        "Test update image",
        arguments: zip(
            [
                "https://image.com/image_update.png",
                "https://image.com/image_other_update.png"
            ] as [String],
            [
                (Image(systemName: "house"), Image(systemName: "bitcoinsign.circle.fill")),
                (Image(systemName: "person"), Image(systemName: "wallet.bifold.fill"))
            ] as [(Image, Image)]
        )
    )
    func updateImage(urlString: String, image: (Image, Image)) throws {
        // Given
        guard let url = URL(string: urlString) else {
            throw ImageCacheError.urlNotValid
        }
        imageCache.remove(url: url)
    
        // When
        imageCache.set(url: url, image: image.0)
        imageCache.set(url: url, image: image.1)

        // Then
        #expect(imageCache.get(url: url) == image.1)
    }
}

extension ImageCacheTests {
    enum ImageCacheError: Error {
        case urlNotValid
    }
}
