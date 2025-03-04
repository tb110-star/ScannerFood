//
//  UserRepository.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import FirebaseFirestore


final class UserRepository {
    private let database = Firestore.firestore()

    func insert(id: String, username: String,birthDate:Date,gender:String) async throws(Error) -> User {
        let user = User(id:id , signedUpOn: .now, userName: username, birthDate: birthDate, gender: gender)
        
        do {
            try database.collection("users").document(id).setData(from: user)
        } catch {
            throw .creationFailed
        }
        
        return try await find(by: id)
    }
    
    func find(by id: String) async throws(Error) -> User {
        do {
            let snapshot = try await database.collection("users").document(id).getDocument()
            return try snapshot.data(as: User.self)
        } catch {
            throw .fetchingFailed
        }
    }
    
    
    enum Error: LocalizedError {
        case fetchingFailed
        case creationFailed
        
        var errorDescription: String? {
            switch self {
            case .creationFailed:
                "The user creation failed."
            case .fetchingFailed:
                "The fetching of the user failed."
            }
        }
    }
    
}
