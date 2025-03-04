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
       
        ZStack(){
            Color.loginback.ignoresSafeArea(.all)

                VStack{
                    Image("login")
                        .resizable()
                        .scaledToFill()
                       .edgesIgnoringSafeArea(.top)
                       .frame(height:250)
                        .blur(radius: 3)
               
                            VStack(spacing: 15) {
                                TextField("Email", text: $authViewModel.email)
                                    .padding(12)
                                    .background(.timberwolf.opacity(0.8))
                                    .cornerRadius(10)
                                
                                HStack {
                                    if authViewModel.showPassword {
                                        TextField("Password", text:$authViewModel.password)
                                    } else {
                                        SecureField("Password(six or more characters)", text: $authViewModel.password)
                                    }
                                    Button(action: {
                                        authViewModel.showPassword.toggle()
                                    }) {
                                        Image(systemName: authViewModel.showPassword ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                                    }
                                }
                                .padding(12)
                                .background(.timberwolf.opacity(0.8))
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
                                        Image(systemName: authViewModel.showPassword ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                                    }
                                }
                                .padding(12)
                                .background(.timberwolf.opacity(0.8))
                                .cornerRadius(10)
                                
                                
                                TextField("Name", text: $authViewModel.name)
                                    .padding(12)
                                    .background(.timberwolf.opacity(0.8))
                                    .cornerRadius(10)
                                DatePicker("Birthdate", selection: $authViewModel.birthDate, displayedComponents: .date)
                                Picker("Gender", selection: $authViewModel.gender, content: {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                })
//                                TextField("Occupation", text: $authViewModel.occupation)
//                                    .padding(12)
//                                    .background(.timberwolf.opacity(0.8))
//                                    .cornerRadius(10)
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
                                    .frame(width: 160, height: 40)
                                    .background(authViewModel.passwordsMatch ? Color.manatee : Color.gray)                    .cornerRadius(25)
                            }
                            .padding()
                            
                        //}
                    
                    Spacer()
                    NavigationLink(destination: LoginView(authViewModel: AuthViewModel())) {
                        Text("Already have an account? Click here to log in.")
                            .foregroundColor(.manatee)
                        
                    }
                }
            
            }
        
    }
}


#Preview {
    RegisterView(authViewModel: AuthViewModel())
}

