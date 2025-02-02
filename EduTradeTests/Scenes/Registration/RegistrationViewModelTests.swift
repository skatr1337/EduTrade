//
//  RegistrationViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 19.01.2025.
//

@testable import EduTrade
import Testing

struct RegistrationViewModelTests {

    let registrationViewModel: RegistrationViewModel
    
    init() {
        registrationViewModel = RegistrationViewModel()
    }
    
    @Test(
        "Test formIsValid",
        arguments: zip(
            [
                ("test@tes.pl", "password", "password", "Name"),
                ("", "password", "password", "Name"),
                ("wrong_email", "password", "password", "Name"),
                ("test@tes.pl", "", "", "Name"),
                ("test@tes.pl", "pass", "pass", "Name"),
                ("test@tes.pl", "password", "wrong_password", "Name"),
                ("test@tes.pl", "password", "password", "")
            ] as [(String, String, String, String)],
            [
                true,
                false,
                false,
                false,
                false,
                false,
                false
            ] as [Bool]
        )
    )
    func formIsValid(input: (String, String, String, String), result: Bool) async throws {
        #expect(
            registrationViewModel.formIsValid(
                email: input.0,
                password: input.1,
                confirmPassword: input.2,
                fullname: input.3
            ) == result
        )
    }

}
