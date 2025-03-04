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
            ZStack{
                Color.loginback.ignoresSafeArea(.all)

            VStack{
                Image("login")
                    .resizable()
                    .scaledToFill()
                   .edgesIgnoringSafeArea(.top)
                   .frame(height:270)
                    .blur(radius: 3)
                Text("Food Scanner")
                    .padding(.bottom)
                    .foregroundColor(.pinkLavenderD)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                VStack(spacing: 15) {
                    TextField("Email", text: $authViewModel.email)
                        .padding(12)
                        .background(.timberwolf.opacity(0.8))
                        .cornerRadius(10)
                    HStack {
                        if authViewModel.showPassword {
                            TextField("Password", text:$authViewModel.password)
                        } else {
                            SecureField("Password", text: $authViewModel.password)
                        }
                        Button(action: {
                            authViewModel.showPassword.toggle()
                        }) {
                            Image(systemName: authViewModel.showPassword ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                        }
                    }
                    .padding(12)
                    .textFieldStyle(.plain)
                    .background(.timberwolf.opacity(0.8))
                    .cornerRadius(10)
                }
                
                .padding()
                Button(action: {
                    
                    authViewModel.signIn()
                    
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(width: 160, height: 40)
                        .background(Color.manatee)
                        .cornerRadius(25)
                }
                .padding(8)
                Button(action: {
                    
                    authViewModel.signInAnonymously()
                    
                }) {
                    Text("Log In as guest!")
                        .foregroundColor(.white)
                        .frame(width: 160, height: 40)
                        .background(Color.manatee)
                        .cornerRadius(25)
                }
                
                Spacer()
                
                NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                    Text("Don't have an account? Click here to register.")
                        .foregroundColor(.manatee)
                }
                .environment(AuthViewModel())
                
                
            }
        }
    }
       }

}

#Preview {
    LoginView(authViewModel: AuthViewModel())

}
