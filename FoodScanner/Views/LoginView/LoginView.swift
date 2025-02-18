//
//  LoginView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import SwiftUI


struct LoginView: View {
    @Bindable var authViewModel: AuthViewModel
//    @State private var email = ""
//    @State private var password = ""
    var body: some View {
        NavigationStack{
        VStack(spacing: 20) {
            Text("Log In")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $authViewModel.email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("Password", text: $authViewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
            }
            .padding(.horizontal)
            Button(action: {
               
                    authViewModel.signIn()
                
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            
            Button(action: {
               
                    authViewModel.signInAnonymously()
               
            }) {
                Text("Log In as guest!")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            
            Spacer()
            
            NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                                Text("Don't have an account? Click here to register.")
                                    .foregroundColor(.blue)
                            }
            .environment(AuthViewModel())


        }
        .padding()
    }
       }

}

#Preview {
    LoginView(authViewModel: AuthViewModel())

}
