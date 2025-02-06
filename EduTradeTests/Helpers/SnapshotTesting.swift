//
//  SnapshotTesting.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 03.02.2025.
//

@testable import EduTrade
import SnapshotTesting
import SwiftUICore

protocol SnapshotTests {
    var config: ViewImageConfig { get }
    var coordinator: MainCoordinator { get }
    func assertSnapshot<V: View>(
        view: @autoclosure (() throws -> V),
        file: String,
        function: String,
        record: Bool)
}

extension SnapshotTests {
    var config: ViewImageConfig {
        .iPhone13(.portrait)
    }

    @MainActor
    var coordinator: MainCoordinator {
        let authServiceMock = AuthServiceMock()
        let cryptoServiceMock = CryptoServiceMock()
        let coordinator = MainCoordinator(
            authService: authServiceMock,
            cryptoService: cryptoServiceMock
        )
        return coordinator
    }

    func assertSnapshot<V: View>(
        view: @autoclosure (() throws -> V),
        file: String = #file,
        function: String = #function,
        record: Bool = false
    ) {
        SnapshotTesting.assertSnapshot(
            of: try view(),
            as: Snapshotting.image(layout: .device(config: config)),
            named: testName(function: function),
            record: record,
            testName: fileName(file)
        )
    }

    private func fileName(_ file: String) -> String {
        let url = URL(fileURLWithPath: file)
        return url.deletingPathExtension().lastPathComponent
    }
    
    private func testName(function: String) -> String {
        function.components(separatedBy: "(").first ?? function
    }
}
