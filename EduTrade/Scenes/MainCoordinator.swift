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
    case home
    case trade(coin: Coin)
    case wallet
    case settings
}

extension Screen {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.container, .container),
            (.login, .login),
            (.registration, .registration),
            (.home, .home),
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

@MainActor
class MainCoordinator: ObservableObject {
    private let authService: AuthServiceProtocol
    private var accountService: AccountServiceProtocol?
    private let cryptoService: CryptoServiceProtocol
    @Published var isLoading = false
    @Published var currentUser: UserDTO?
    @Published var path: NavigationPath = NavigationPath()
    var viewModel: HomeViewModel?

    init(
        authService: AuthServiceProtocol = AuthService(),
        cryptoService: CryptoServiceProtocol = CryptoService()
    ) {
        self.authService = authService
        self.cryptoService = cryptoService
        login()
    }

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
    func push(screen: Screen) {
        path.append(screen)
    }

    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .container:
            ContainerView()
        case .login:
            let viewModel = LoginViewModel()
            LoginView(viewModel: viewModel)
        case .registration:
            let viewModel = RegistrationViewModel()
            RegistrationView(viewModel: viewModel)
        case .home:
            if let viewModel {
                HomeView(viewModel: viewModel)
            }
        case let .trade(coin):
            TradeView(coin: coin)
        case .wallet:
            WalletView()
        case .settings:
            SettingsView()
        }
    }
}

// MARK: Authentication

extension MainCoordinator {
    func signIn(withEmail email: String, password: String) async throws {
        try await authService.signIn(email: email, password: password)
        updateCurrentUser()
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        try await authService.createUser(email: email, password: password, fullname: fullname)
        updateCurrentUser()
        try await accountService?.updateInitialCryptos()
    }

    func signOut() {
        try? authService.signOut()
        updateCurrentUser()
    }

    private func fetchCurrentUser() async throws {
        try await authService.fetchCurrentUser()
        updateCurrentUser()
    }

    private func updateCurrentUser() {
        currentUser = authService.currentUser
        guard let uid = currentUser?.id else {
            accountService = nil
            return
        }
        accountService = AccountService(uid: uid)
        if let accountService {
            viewModel = HomeViewModel(
                cryptoService: cryptoService,
                accountService: accountService
            )
        }
    }
}

// MARK: Account

extension MainCoordinator {
    func updateCryptos(cryptos: Set<AccountDTO.CryptoDTO>) async throws {
        try await accountService?.updateCryptos(cryptos: cryptos)
    }

    func getAccount() async throws -> AccountDTO? {
        try await accountService?.getAccount()
    }
}
