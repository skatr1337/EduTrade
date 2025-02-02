//
//  RegistrationView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import SwiftUI

struct RegistrationView<ViewModel: RegistrationViewModelProtocol>: View, InspectableView {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: ViewModel

    var didAppear: ((Self) -> Void)?
    
    var body: some View {
        let formIsValid = viewModel.formIsValid(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            fullname: fullname
        )
        VStack {
            Image("Bitcoin")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
                .accessibilityIdentifier("image")
            
            VStack(spacing: 24) {
                InputView(
                    text: $email,
                    title: String(localized: "Email Address"),
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)
                
                InputView(
                    text: $fullname,
                    title: String(localized: "Full Name"),
                    placeholder: String(localized: "Enter your name")
                )
                
                InputView(
                    text: $password,
                    title: String(localized: "Password"),
                    placeholder: String(localized: "Enter your Password"),
                    isSecureField: true
                )
                
                ZStack(alignment: .trailing) {
                    InputView(
                        text: $confirmPassword,
                        title: String(localized: "Confirm password"),
                        placeholder: String(localized: "Confirm your Password"),
                        isSecureField: true
                    )
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await coordinator.createUser(withEmail: email,
                        password: password,
                        fullname: fullname)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            .accessibilityIdentifier("signUpButton")
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
        .onAppear {
            didAppear?(self)
        }
    }
}

#Preview {
    RegistrationView(viewModel: RegistrationViewModel())
}
