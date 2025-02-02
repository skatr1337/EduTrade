//
//  LoginViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

@testable import EduTrade

class LoginViewModelMock: LoginViewModelProtocol {
    var isValid = true
    func formIsValid(email: String, password: String) -> Bool {
        isValid
    }
}
