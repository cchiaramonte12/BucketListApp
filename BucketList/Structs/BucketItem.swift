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

    var id: UUID
    let title: String
    var isCompleted: Bool
    
}
