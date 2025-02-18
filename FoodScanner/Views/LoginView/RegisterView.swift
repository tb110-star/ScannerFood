//
//  RegisterView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import SwiftUI

struct RegisterView: View {
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $authViewModel.email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
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
                        Image(systemName: authViewModel.showPassword ? "eye.slash.fill" : "eye.fill")
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                HStack {
                    if authViewModel.showPassword {
                        TextField("Confirm Password", text:$authViewModel.confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                    }
                    Button(action: {
                        authViewModel.showPassword.toggle()
                    }) {
                        Image(systemName: authViewModel.showPassword ? "eye.slash.fill" : "eye.fill")
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                
                TextField("Name", text: $authViewModel.name)
                DatePicker("Birthdate", selection: $authViewModel.birthDate, displayedComponents: .date)
                Picker("Gender", selection: $authViewModel.gender, content: {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                })
                TextField("Occupation", text: $authViewModel.occupation)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            .padding(.horizontal)
            
            Button(action: {
                if authViewModel.passwordsMatch {
                   
                    authViewModel.signUp(email: authViewModel.email, password:authViewModel.password , name:authViewModel.name , birthDate:authViewModel.birthDate , gender: authViewModel.gender, job: authViewModel.occupation)
                    
                }
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(authViewModel.passwordsMatch ? Color.blue : Color.gray)                    .cornerRadius(25)
            }
            
            Spacer()
            
            NavigationLink(destination: LoginView(authViewModel: AuthViewModel())) {
                Text("Already have an account? Click here to log in.")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}


#Preview {
    RegisterView(authViewModel: AuthViewModel())
}

