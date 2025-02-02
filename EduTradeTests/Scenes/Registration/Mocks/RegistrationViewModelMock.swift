//
//  RegistrationViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 02.02.2025.
//

@testable import EduTrade

class RegistrationViewModelMock: RegistrationViewModelProtocol {
    var isValid = true
    func formIsValid(
        email: String,
        password: String,
        confirmPassword: String,
        fullname: String
    ) -> Bool {
        isValid
    }
}
