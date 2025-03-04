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

@MainActor
@Observable

final class AuthViewModel {
    var user: User?
    var errorMessage: String?
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
                errorMessage = nil
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
            } catch {
                errorMessage = error.localizedDescription
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

  
