//
//  ViewBaseTest.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 29.01.2025.
//

@testable import EduTrade
import Testing
import ViewInspector

enum ViewInspectorError: Error {
    case viewNotFound
    case setupFailed
}

// The main idea of this protocol is to inject coordinator inside the view

protocol BaseViewTest {
    associatedtype V: EduTrade.InspectableView
    func setup(_ view: V, coordinator: MainCoordinator?) async throws -> V
}

extension BaseViewTest {
    @MainActor
    func setup(_ view: V, coordinator: MainCoordinator? = nil) async throws -> V {
        let coordinator = coordinator ?? makeCoordinator()
        var newView = view
        var resultView: V?

        await confirmation() { confirmation in
            newView.on(\.didAppear) { view in
                resultView = try view.find(V.self).actualView()
                confirmation()
            }
            ViewHosting.host(view: newView.environmentObject(coordinator))
            try? await Task.sleep(nanoseconds: 1_000_000)
        }
        if let resultView {
            return resultView
        } else {
            throw ViewInspectorError.setupFailed
        }
    }

    @MainActor
    private func makeCoordinator() -> MainCoordinator {
        let authServiceMock = AuthServiceMock()
        let cryptoServiceMock = CryptoServiceMock()
        let coordinator = MainCoordinator(
            authService: authServiceMock,
            cryptoService: cryptoServiceMock
        )
        return coordinator
    }
}
