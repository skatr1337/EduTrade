//
//  AuthServiceMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 13.01.2025.
//

@testable import EduTrade

class AuthServiceMock: AuthServiceProtocol {
    var calledMethods: [String] = []

    var currentUser: UserDTO?
    
    func signIn(email: String, password: String) async throws {
        calledMethods.append(#function)
    }
    
    func createUser(email: String, password: String, fullname: String) async throws {
        calledMethods.append(#function)
    }
    
    func fetchCurrentUser() async throws {
        calledMethods.append(#function)
    }
    
    func signOut() throws {
        calledMethods.append(#function)
    }
}
