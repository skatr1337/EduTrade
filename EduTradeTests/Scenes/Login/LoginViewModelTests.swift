//
//  LoginViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 19.01.2025.
//

@testable import EduTrade
import Testing

struct LoginViewModelTests {
    let loginViewModel: LoginViewModel
    
    init() {
        loginViewModel = LoginViewModel()
    }
    
    @Test(
        "Test formIsValid",
        arguments: zip(
            [
                ("test@tes.pl", "password"),
                ("", "password"),
                ("wrong_email", "password"),
                ("test@tes.pl", ""),
                ("test@tes.pl", "pass")
            ] as [(String, String)],
            [
                true,
                false,
                false,
                false,
                false
            ] as [Bool]
        )
    )
    func formIsValid(input: (String, String), result: Bool) async throws {
        #expect(loginViewModel.formIsValid(email: input.0, password: input.1) == result)
    }
}
