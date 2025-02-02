//
//  AuthService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 12.12.2024.
//

import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    var currentUser: UserDTO? { get }
    func signIn(email: String, password: String) async throws
    func createUser(email: String, password: String, fullname: String) async throws
    func fetchCurrentUser() async throws
    func signOut() throws
}

class AuthService: AuthServiceProtocol, ObservableObject {
    private let auth: Auth
    private let usersCollection: CollectionReference
    private var userSession: FirebaseAuth.User?

    @Published var currentUser: UserDTO?

    init() {
        self.auth = Auth.auth()
        self.usersCollection = Firestore.firestore().collection("users")
        self.userSession = Auth.auth().currentUser
    }

    func signIn(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        userSession = result.user
        try await fetchCurrentUser()
    }

    func createUser(email: String, password: String, fullname: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        userSession = result.user
        let user = UserDTO(id: result.user.uid, fullname: fullname, email: email)
        let encodedUser = try Firestore.Encoder().encode(user)
        try await usersCollection.document(user.id).setData(encodedUser)
        try await fetchCurrentUser()
    }

    func fetchCurrentUser() async throws {
        guard let uid = auth.currentUser?.uid else {
            throw AuthServiceError.userNotFound
        }
        let snapshot = try await usersCollection.document(uid).getDocument()
        currentUser = try snapshot.data(as: UserDTO.self)
    }

    func signOut() throws {
        try auth.signOut()
        userSession = nil
        currentUser = nil
    }
}

extension AuthService {
    enum AuthServiceError: Error {
        case userNotFound
    }

    func localizeddDscription(error: Error) -> String {
        switch error {
        case AuthServiceError.userNotFound:
            "User not found"
        default:
            "Unknown error"
        }
    }
}
