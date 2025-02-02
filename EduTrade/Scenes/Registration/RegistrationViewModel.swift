//
//  RegistrationViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import Foundation

protocol RegistrationViewModelProtocol: ObservableObject {
    func formIsValid(
        email: String,
        password: String,
        confirmPassword: String,
        fullname: String
    ) -> Bool
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    func formIsValid(
        email: String,
        password: String,
        confirmPassword: String,
        fullname: String
    ) -> Bool {
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count > 5 &&
        confirmPassword == password &&
        !fullname.isEmpty
    }
}
