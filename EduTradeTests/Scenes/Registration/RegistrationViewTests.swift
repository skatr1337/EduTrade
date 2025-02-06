//
//  RegistrationViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 02.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct RegistrationViewTests: BaseViewTest {
    let viewModel: RegistrationViewModelMock
    let registrationView: RegistrationView<RegistrationViewModelMock>
    let authServiceMock: AuthServiceMock
    let cryptoServiceMock: CryptoServiceMock
    let coordinator: MainCoordinator

    @MainActor
    init() throws {
        viewModel = RegistrationViewModelMock()
        registrationView = RegistrationView(viewModel: viewModel)
        authServiceMock = AuthServiceMock()
        cryptoServiceMock = CryptoServiceMock()
        coordinator = MainCoordinator(
            authService: authServiceMock,
            cryptoService: cryptoServiceMock
        )
    }

    @Test("Test registrationView")
    @MainActor
    func registrationView() async throws {
        // When
        let view = registrationView.environmentObject(coordinator)

        // Then
        let inspect = try view.inspect()
        let image = try inspect.find(viewWithAccessibilityIdentifier: "image").image()
        let testImage = Image("Bitcoin").resizable()
        try #expect(image.actualImage() == testImage)

        let textFields = inspect.findAll(ViewType.TextField.self)
        let email = try textFields.first?.find(viewWithAccessibilityIdentifier: "textField").textField()
        let name = try textFields.last?.find(viewWithAccessibilityIdentifier: "textField").textField()
        let secureFields = inspect.findAll(ViewType.SecureField.self)
        let password = try secureFields.first?.find(viewWithAccessibilityIdentifier: "secureField")
            .secureField()
        let repeatPassword = try secureFields.last?.find(viewWithAccessibilityIdentifier: "secureField")
            .secureField()
        try #expect(email?.input() == "")
        try #expect(name?.input() == "")
        try #expect(password?.input() == "")
        try #expect(repeatPassword?.input() == "")
        let signUpButton = try inspect.find(viewWithAccessibilityIdentifier: "signUpButton").button()
        try signUpButton.tap()
        #expect(authServiceMock.calledMethods.contains("fetchCurrentUser()"))
    }
}
