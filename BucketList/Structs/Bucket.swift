//
//  Bucket.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Bucket: Identifiable, Hashable, Codable {
    
    var id: UUID
    var title: String
    var date: Date
    var description: String?
    var headerImageUrl: String?
    var items: [BucketItem]?
    var color: String?
    
    var fallbackColor: UIColor {
        getRandomColor()
    }
    
}

