//
//  HomeViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import Foundation
import Combine

class HomeViewModel: ViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentUser: User?
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        $currentUser.sink { user in
            guard user != nil else { return }
            self.refresh()
        }
        .store(in: &cancellables)
    }
    var title: String { "Home" }
    
    @Published var buckets: [Bucket]?
    
    init() {
        refresh()
        setupSubscribers()
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            guard let userId = currentUser?.id else {
                throw BucketListErrors.currentUserIdNil
            }
            let buckets = try await FirebaseService.shared.getBuckets(for: userId)
            
            await MainActor.run {
                self.buckets = buckets
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

protocol ViewModel: ObservableObject {
    var title: String { get }
    func refresh()
    func asyncRefresh() async
}
