//
//  BucketItem.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct BucketItem: Identifiable, Hashable, Codable {
    
    static func == (lhs: BucketItem, rhs: BucketItem) -> Bool {
        return lhs.id == rhs.id
    }

    // Manual Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    var id: UUID
    let title: String
    var isCompleted: Bool
    var locationName: String?
    var locationAddress: String?
    var latitude: Float?
    var longitude: Float?
//    var location: Location?
}

extension BucketItem: FirebaseSafe {
    var dehydratedObject: BucketItem {
        self
    }
}
