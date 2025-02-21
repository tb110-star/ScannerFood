//
//  AuthManager.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//


import FirebaseAuth
@MainActor
@Observable

final class AuthManager {
    static let shared = AuthManager()
    private init() {
        checkAuth()
    }
    
    var isUserSignedIn: Bool {
        user != nil
    }
    var userID: String? {
        user?.uid
    }
    
    var email: String? {
        user?.email
    }
    
    func signInAnonymously() async throws(Error) {
        do {
            let result = try await auth.signInAnonymously()
            user = result.user
            // no email with anonymous login, i.e. no fireUser assignment.
        } catch {
            throw .signUpAnonymouslyFailed(reason: error.localizedDescription)
        }
    }
    func signUp(email: String, password: String) async throws(Error) {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            user = result.user
        } catch {
            throw .signUpFailed(reason: error.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String) async throws(Error) {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            user = result.user
        } catch {
            throw .signInFailed(reason: error.localizedDescription)
        }
    }
    
    func signOut() throws(Error) {
        do {
            try auth.signOut()
            user = nil
        } catch {
            throw .signOutFailed(reason: error.localizedDescription)
        }
    }
    
   
    private func checkAuth() {
        user = auth.currentUser
    }

    private let auth = Auth.auth()

  
    private var user: FirebaseAuth.User?


    enum Error: LocalizedError {
        case signOutFailed(reason: String)
        case signInFailed(reason: String)
        case signUpFailed(reason: String)
        case signUpAnonymouslyFailed(reason: String)
        
        var errorDescription: String? {
            switch self {
            case .signOutFailed(let reason):
                "The sign out failed: \(reason)"
            case .signInFailed(let reason):
                "The sign in failed: \(reason)"
            case .signUpFailed(let reason):
                "The sign up failed: \(reason)"
            case .signUpAnonymouslyFailed(let reason):
                "The anonymous sign up failed: \(reason)"
            }
        }
    }
    
    
}
