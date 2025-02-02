//
//  MainCoordinator.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import SwiftUI

enum Screen: Hashable {
    case container
    case login
    case registration
    case markets
    case trade(coin: Coin)
    case wallet
    case settings
}

enum FullScreenCover: String, Identifiable {
    case transations

    var id: String {
        self.rawValue
    }
}

extension Screen {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.container, .container),
            (.login, .login),
            (.registration, .registration),
            (.markets, .markets),
            (.trade, .trade),
            (.wallet, .wallet),
            (.settings, .settings):
            true
        default:
            false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

protocol MainCoordinatorProtocol: ObservableObject {
    var isLoading: Bool { get }
    var currentUser: UserDTO? { get }
    var path: NavigationPath { get }
    var fullScreenCover: FullScreenCover? { get }
    func push(screen: Screen) async
    func pop() async
    func popToRoot() async
    func presentFullScreenCover(_ cover: FullScreenCover) async
    func dismissFullScreenCover() async
    func signIn(withEmail email: String, password: String) async throws
    func createUser(withEmail email: String, password: String, fullname: String) async throws
    func signOut() async throws
    func getAccount() async throws -> AccountDTO?
}

class MainCoordinator: MainCoordinatorProtocol {
    private let authService: AuthServiceProtocol
    private var walletService: WalletServiceProtocol?
    private let cryptoService: CryptoServiceProtocol
    private var marketsViewModel: MarketsViewModel?
    private let loginViewModel = LoginViewModel()
    private let registrationViewModel = RegistrationViewModel()
    private var walletViewModel: WalletViewModel?
    private var tradeViewModel: TradeViewModel?
    private var transactionsViewModel: TransactionsViewModel?

    @MainActor @Published
    var isLoading = false
    @MainActor @Published
    var currentUser: UserDTO?
    @MainActor @Published
    var path: NavigationPath = NavigationPath()
    @MainActor @Published
    var fullScreenCover: FullScreenCover?

    @MainActor
    init(
        authService: AuthServiceProtocol = AuthService(),
        cryptoService: CryptoServiceProtocol = CryptoService()
    ) {
        self.authService = authService
        self.cryptoService = cryptoService
        login()
    }

    @MainActor
    private func login() {
        isLoading = true
        Task {
            try? await fetchCurrentUser()
            isLoading = false
        }
    }
}

// MARK: Navigation

extension MainCoordinator {
    @MainActor
    func push(screen: Screen) {
        path.append(screen)
    }

    @MainActor
    func pop() {
        path.removeLast()
    }

    @MainActor
    func popToRoot() {
        path.removeLast(path.count)
    }

    @MainActor
    func presentFullScreenCover(_ cover: FullScreenCover) {
        fullScreenCover = cover
    }

    @MainActor
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }

    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .container:
            ContainerView()
        case .login:
            LoginView(viewModel: loginViewModel)
        case .registration:
            RegistrationView(viewModel: registrationViewModel)
        case .markets:
            if let marketsViewModel {
                MarketsView(viewModel: marketsViewModel)
            }
        case let .trade(coin):
            if let tradeViewModel {
                TradeView(viewModel: tradeViewModel, coin: coin)
            }
        case .wallet:
            if let walletViewModel {
                WalletView(viewModel: walletViewModel)
            }
        case .settings:
            SettingsView()
        }
    }

    @ViewBuilder
    func build(cover: FullScreenCover) -> some View {
        switch cover {
        case .transations:
            if let transactionsViewModel {
                TransactionsView(viewModel: transactionsViewModel)
            }
        }
    }
}

// MARK: Authentication

extension MainCoordinator {
    @MainActor
    func signIn(withEmail email: String, password: String) async throws {
        try await authService.signIn(email: email, password: password)
        updateCurrentUser()
    }

    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        try await authService.createUser(email: email, password: password, fullname: fullname)
        updateCurrentUser()
        try await walletService?.makeInitialCryptos()
    }

    @MainActor
    func signOut() throws {
        try authService.signOut()
        updateCurrentUser()
    }

    @MainActor
    private func fetchCurrentUser() async throws {
        try await authService.fetchCurrentUser()
        updateCurrentUser()
    }

    @MainActor
    private func updateCurrentUser() {
        currentUser = authService.currentUser
        guard let uid = currentUser?.id else {
            walletService = nil
            return
        }
        walletService = WalletService(uid: uid)
        guard let walletService else { return }
        
        marketsViewModel = MarketsViewModel(
            cryptoService: cryptoService,
            walletService: walletService
        )
        walletViewModel = WalletViewModel(
            cryptoService: cryptoService,
            walletService: walletService
        )
        tradeViewModel = TradeViewModel(
            cryptoService: cryptoService,
            walletService: walletService
        )
        transactionsViewModel = TransactionsViewModel(
            walletService: walletService
        )
    }
}

// MARK: Account

extension MainCoordinator {
    func getAccount() async throws -> AccountDTO? {
        try await walletService?.getAccount()
    }
}
