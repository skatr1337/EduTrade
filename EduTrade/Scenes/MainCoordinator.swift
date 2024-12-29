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
    private var walletService: WalletServiceProtocol?
    private let cryptoService: CryptoServiceProtocol
    private var homeViewModel: HomeViewModel?
    private let loginViewModel = LoginViewModel()
    private let registrationViewModel = RegistrationViewModel()
    private var walletViewModel: WalletViewModel?
    private var tradeViewModel: TradeViewModel?
    private var transactionsViewModel: TransactionsViewModel?

    @Published var isLoading = false
    @Published var currentUser: UserDTO?
    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?

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

    func presentFullScreenCover(_ cover: FullScreenCover) {
        fullScreenCover = cover
    }

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
        case .home:
            if let homeViewModel {
                HomeView(viewModel: homeViewModel)
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
    func signIn(withEmail email: String, password: String) async throws {
        try await authService.signIn(email: email, password: password)
        updateCurrentUser()
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        try await authService.createUser(email: email, password: password, fullname: fullname)
        updateCurrentUser()
        try await walletService?.makeInitialCryptos()
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
            walletService = nil
            return
        }
        walletService = WalletService(uid: uid)
        guard let walletService else { return }
        
        homeViewModel = HomeViewModel(
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
