//
//  ForgotPasswordView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 10.03.25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack{
            Color.loginback.ignoresSafeArea(.all)

        VStack(spacing: 20) {
            Text("Reset your password")
                .foregroundColor(.pinkLavenderD)
                .font(.title2)
                .bold()
            
            TextField("Enter your email", text: $email)
                .padding(12)
                .background(.timberwolf.opacity(0.8))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            Button("Send reset link") {
                Task {
                    await resetPassword()
                }
            }
            .foregroundColor(.white)
            .frame(width: 160, height: 40)
            .background(Color.manatee)
            .cornerRadius(25)
        }
        .padding(12)
        .alert("Info", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    }

    private func resetPassword() async {
        do {
             authViewModel.sendPasswordResetEmail(email: email)
            alertMessage = "✅ Check your email to reset your password."
            showAlert = true
        }
    }
}

#Preview {
    ForgotPasswordView(authViewModel: AuthViewModel())
}
