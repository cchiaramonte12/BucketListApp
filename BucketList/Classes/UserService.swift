//
//  UserService.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/16/23.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?

    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return } // make sure we have a currently logged in user
        // find user relative to their user id
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        // decode user from data we get from snapshot
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    // reset user data for logout
    func reset() {
        self.currentUser = nil
    }
}
