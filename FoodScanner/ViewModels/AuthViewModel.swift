//
//  AuthViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import Foundation

import Firebase
import FirebaseAuth
import Combine
import SwiftUICore
import GoogleSignIn
@MainActor
@Observable

final class AuthViewModel {
    var user: User?
    var errorMessage: String?
    var showError: Bool = false
    var email: String = ""
    var password: String = ""
    var confirmPassword = ""
    var showPassword = false
    var name: String = ""
    var birthDate: Date = Date()
    var gender: String = ""
    var occupation: String = ""
    var passwordsMatch: Bool {
        password == confirmPassword
    }
    var isUserSignedIn: Bool {
        AuthManager.shared.isUserSignedIn
    }
    private let userRepository = UserRepository()
    func signInWithGoogle() {
        Task {
            do {
                try await AuthManager.shared.signInWithGoogle()
                 fetchCurrentUser()
                print("✅ login via Google successfully")
            } catch {
                errorMessage = error.localizedDescription
                print("❌ error within Google login: \(error.localizedDescription)")
            }
        }
    }

    func sendPasswordResetEmail(email: String) {
        Task{
            do{
                try await AuthManager.shared.sendPasswordResetEmail(email: email)
            }catch{
                errorMessage = error.localizedDescription
            }
        }
       }
    func signInAnonymously() {
        Task {
            do {
                try await AuthManager.shared.signInAnonymously()
              //  let userID = AuthManager.shared.userID!
              //  let email = AuthManager.shared.email!
               // self.user = try await userRepository.insert(id: userID, createdOn: .now)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        Task {
            try? AuthManager.shared.signOut()
            user = nil
        }
    }
   
    func signUp(email: String, password:String , name:String , birthDate:Date , gender: String, job: String) {
        Task {
            do {
                try await AuthManager.shared.signUp(email: email, password: password)
                let userID = AuthManager.shared.userID!
              //  let email = AuthManager.shared.email!
                self.user = try await userRepository.insert(id: userID, username: name, birthDate: birthDate, gender: gender)
                errorMessage = "E-Mail or Password is not correct! "
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await AuthManager.shared.signIn(email: email, password: password)
                let userID = AuthManager.shared.userID!
                user = try await userRepository.find(by: userID)
                errorMessage = nil
                showError = false
            } catch {
                errorMessage = error.localizedDescription
                print("❌ username or password is wrong!")
                showError = true
            }
        }
    }
    
    init() {
        _ = AuthManager.shared
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        Task {
            do {
                if let userID = AuthManager.shared.userID {
                    user = try await userRepository.find(by: userID)
                }
            } catch {
                errorMessage = "The user is not signed in."
            }
        }
    }
    
}

  
