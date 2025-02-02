//
//  AsyncImageCachedTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 28.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector

struct AsyncImageCachedTests {
    @Test("Test not existing image")
    @MainActor
    func notExistingImage() async throws {
        // Given
        guard let url = URL(string: "not.existing.image.ch") else {
            throw AsyncImageCachedError.urlNotValid
        }

        // When
        let asyncImageCached = AsyncImageCached(url: url) { _ in }

        // Then
        let asyncImage = try asyncImageCached.body.inspect().find(ViewType.AsyncImage.self)
        #expect(try asyncImage.url() == url)
    }
}

extension AsyncImageCachedTests {
    enum AsyncImageCachedError: Error {
        case urlNotValid
    }
}
