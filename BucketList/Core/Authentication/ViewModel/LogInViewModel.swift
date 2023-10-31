//
//  LogInViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation

class LogInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
