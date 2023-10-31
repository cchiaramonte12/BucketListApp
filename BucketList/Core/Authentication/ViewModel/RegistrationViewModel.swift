//
//  RegistrationViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    @MainActor
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email,
                                      password: password,
                                      fullname: fullname,
                                      username: username)
    }
}
