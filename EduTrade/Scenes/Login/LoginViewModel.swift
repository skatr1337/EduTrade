//
//  AuthViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    func formIsValid(email: String, password: String) -> Bool {
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count > 5
    }
}
