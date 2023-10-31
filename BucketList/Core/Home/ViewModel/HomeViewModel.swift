//
//  HomeViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import Foundation

class HomeViewModel: ViewModel {
    
    var title: String { "Home" }
    
    @Published var buckets: [Bucket]?
    
    init() {
        refresh()
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            let buckets = try await FirebaseService.shared.getBuckets()
            
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
