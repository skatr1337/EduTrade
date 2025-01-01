//
//  LoginView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        let formIsValid = viewModel.formIsValid(email: email, password: password)
        NavigationStack {
            VStack {
                
                // image
                Image("Bitcoin")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // form fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: String(localized: "Email Address"),
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: String(localized: "Password"),
                              placeholder: String(localized: "Enter your Password"), isSecureField: true)
                
                }
                
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                Button {
                    Task {
                        try await  coordinator.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
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

                Spacer()
                
                //sign up button
                NavigationLink {
                    coordinator.build(screen: .registration)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Dont have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
