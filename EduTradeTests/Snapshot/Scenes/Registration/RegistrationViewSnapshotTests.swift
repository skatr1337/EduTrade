//
//  RegistrationViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct RegistrationViewSnapshotTests: SnapshotTests {
    let viewModel: RegistrationViewModelMock
    let registrationView: RegistrationView<RegistrationViewModelMock>

    @MainActor
    init() throws {
        viewModel = RegistrationViewModelMock()
        registrationView = RegistrationView(viewModel: viewModel)
    }

    @Test("Test registration")
    @MainActor
    func registrationView() async throws {
        // Given
        let view = registrationView.environmentObject(coordinator)
        
        // Then
        assertSnapshot(view: view)
    }
}
