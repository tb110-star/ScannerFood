//
//  AuthManager.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//
import FirebaseCore

import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
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
    func signInWithGoogle() async throws {
        guard (FirebaseApp.app()?.options.clientID) != nil else {
                throw URLError(.badURL)
            }

            guard let rootViewController =  UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                throw URLError(.cannotFindHost)
            }

            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            guard let idToken = result.user.idToken?.tokenString else {
                throw URLError(.badServerResponse)
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
           let authResult =  try await Auth.auth().signIn(with: credential)
            self.user = authResult.user
           var displayName = authResult.user.displayName ?? "User"
           try await saveUserToDatabase(user: authResult.user, displayName: displayName)
        }
    
    func saveUserToDatabase(user: FirebaseAuth.User, displayName: String) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        let document = try await userRef.getDocument()
        
        if !document.exists {
            let userData: [String: Any] = [
                "uid": user.uid,
                "email": user.email ?? "",
                "displayName": displayName,
                "signedUpOn": Timestamp(date: Date())
            ]

            try await userRef.setData(userData)
        }
    }

    func sendPasswordResetEmail(email: String) async throws {
           try await Auth.auth().sendPasswordReset(withEmail: email)
       }
    func signInAnonymously() async throws(Error) {
        do {
            let result = try await auth.signInAnonymously()
            user = result.user
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

     func checkAuth() {
        user = auth.currentUser
    }
    func clearUser() {
        user = nil
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
