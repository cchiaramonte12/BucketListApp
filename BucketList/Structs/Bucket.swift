//
//  Bucket.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirebaseSafe: Codable{
    var dehydratedObject: Self { get }
}

struct Bucket: Identifiable, Hashable, Codable {
    
    
    //MARK: Main Variables
    var id: UUID
    var title: String
    var date: Date
    var description: String?
    var headerImageUrl: String?
    var color: String?
    
    
    //MARK: Computed Variables
    var fallbackColor: UIColor {
        getRandomColor()
    }
    
    //MARK: Dehydrated Variables
    var items: [BucketItem]?
    
}

extension Bucket: FirebaseSafe {
    var dehydratedObject: Bucket {
        .init(id: id, title: title, date: date, description: description, headerImageUrl: headerImageUrl, color: color)
    }
}
