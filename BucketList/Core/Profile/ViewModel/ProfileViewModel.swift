//
//  ProfileViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/16/23.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
