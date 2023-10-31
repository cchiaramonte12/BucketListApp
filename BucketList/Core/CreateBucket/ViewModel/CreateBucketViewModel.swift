//
//  CreateBucketViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import Combine
import Foundation
import Firebase

class CreateBucketViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var description = ""
    @Published var headerImage = ""
    @Published var items = [BucketItem]()

    
    func uploadBucket() async throws {
        let bucket = Bucket(id: UUID(), title: title, date: Date(), description: description, headerImage: headerImage.isEmpty ? nil : "", items: items)
        try await FirebaseService.shared.uploadBucket(bucket)
    }
     

}
