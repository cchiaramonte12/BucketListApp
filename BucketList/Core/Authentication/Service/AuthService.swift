//
//  AuthService.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Firebase
import FirebaseFirestoreSwift

class AuthService {
    
    static let shared = AuthService()
    
    // keep track of whether or not user is logged in
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        self.userSession = Auth.auth().currentUser // from Firebase to track user if logged in or not
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            try? await Auth.auth().currentUser?.reload()
            if Auth.auth().currentUser?.isEmailVerified == true {
                self.userSession = result.user
                try await UserService.shared.fetchCurrentUser() // fetch user data of user you log in with
            } else {
                print("DEBUG: User has not verified their email")
            }
        } catch {
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await Auth.auth().currentUser?.sendEmailVerification()
            self.userSession = result.user
            try await uploadUserData(withEmail: email, fullname: fullname, username: username, id: result.user.uid)
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut() // signs out on backend
        self.userSession = nil // removes session locally and updates routing
        UserService.shared.reset() // reset user info on sign out
    }
    
    // upload user data when they sign up
    @MainActor
    private func uploadUserData(
        withEmail email: String,
        fullname: String,
        username: String,
        id: String)
    async throws {
        let user = User(id: id, fullname: fullname, email: email, username: username) // do NOT include password
        // encode the data
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user // update user info for createUser
    }
}
