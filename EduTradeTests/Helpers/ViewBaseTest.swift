//
//  ViewBaseTest.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 29.01.2025.
//

@testable import EduTrade
import Testing
import ViewInspector

protocol BaseViewTest {
    var coordinator: MainCoordinator { get }
}

extension BaseViewTest {
    @MainActor var coordinator: MainCoordinator {
        let authServiceMock = AuthServiceMock()
        let cryptoServiceMock = CryptoServiceMock()
        let coordinator = MainCoordinator(
            authService: authServiceMock,
            cryptoService: cryptoServiceMock
        )
        return coordinator
    }
}
