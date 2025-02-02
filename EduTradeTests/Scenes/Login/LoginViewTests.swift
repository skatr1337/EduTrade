//
//  LoginViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct LoginViewTests: BaseViewTest {
    typealias V = LoginView<LoginViewModelMock>
    let viewModel: LoginViewModelMock
    let loginView: LoginView<LoginViewModelMock>
    let authServiceMock: AuthServiceMock
    let cryptoServiceMock: CryptoServiceMock
    let coordinator: MainCoordinator

    @MainActor
    init() throws {
        viewModel = LoginViewModelMock()
        loginView = LoginView(viewModel: viewModel)
        authServiceMock = AuthServiceMock()
        cryptoServiceMock = CryptoServiceMock()
        coordinator = MainCoordinator(
            authService: authServiceMock,
            cryptoService: cryptoServiceMock
        )
    }

    @Test("Test loginView")
    @MainActor
    func loginView() async throws {
        // When
        let view = try await setup(loginView, coordinator: coordinator)

        // Then
        let inspect = try view.inspect()
        let image = try inspect.find(viewWithAccessibilityIdentifier: "image").image()
        let testImage = Image("Bitcoin").resizable()
        try #expect(image.actualImage() == testImage)
        let secureField = try inspect.find(viewWithAccessibilityIdentifier: "secureField").secureField()
        try #expect(secureField.input() == "")
        let textField = try inspect.find(viewWithAccessibilityIdentifier: "textField").textField()
        try #expect(textField.input() == "")
        let signInButton = try inspect.find(viewWithAccessibilityIdentifier: "signInButton").button()
        try signInButton.tap()
        #expect(authServiceMock.calledMethods.contains("fetchCurrentUser()"))
    }
}
