//
//  LoginViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 04.02.2025.
//

@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct LoginViewSnapshotTests: SnapshotTests {
    let viewModel: LoginViewModelMock
    let loginView: LoginView<LoginViewModelMock>

    @MainActor
    init() throws {
        viewModel = LoginViewModelMock()
        loginView = LoginView(viewModel: viewModel)
    }

    @Test("Test loginView")
    @MainActor
    func loginView() async throws {
        // Given
        let view = loginView.environmentObject(coordinator)
        
        // Then
        assertSnapshot(view: view)
    }
}
