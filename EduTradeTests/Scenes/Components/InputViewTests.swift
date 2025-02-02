//
//  InputViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SwiftUI
import ViewInspector

struct InputViewTests {
    @Test(
        "Test inputView",
        arguments: [
            ("text", "title", false),
            ("text2", "title2", true)
        ] as [(String, String, Bool)]
    )
    @MainActor
    func inputView(input: (String, String, Bool)) async throws {
        // When
        var inputView = InputView(
            text: .constant(input.0),
            title: input.1,
            placeholder: ""
        )
        inputView.isSecureField = input.2

        // Then
        let inspect = try inputView.inspect()
        let label = try inspect.find(viewWithAccessibilityIdentifier: "text").text()
        try #expect(label.string() == input.1)
        if input.2 {
            let field = try inspect.find(viewWithAccessibilityIdentifier: "secureField").secureField()
            try #expect(field.input() == input.0)
        } else {
            let field = try inspect.find(viewWithAccessibilityIdentifier: "textField").textField()
            try #expect(field.input() == input.0)
        }
    }
}
