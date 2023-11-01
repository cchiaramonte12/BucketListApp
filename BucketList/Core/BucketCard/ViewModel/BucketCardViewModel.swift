//
//  BucketCardViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/20/23.
//

import Foundation

class BucketCardViewModel: ViewModel {
    
    var title: String { "Card" }
    
    @Published var bucket: Bucket
    
    init(bucket: Bucket) {
        self.bucket = bucket
        refresh()
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            let bucket = try await FirebaseService.shared.getBucket(id: bucket.id)
            
            await MainActor.run {
                self.bucket = bucket
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
