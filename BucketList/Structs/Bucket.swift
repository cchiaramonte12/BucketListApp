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

struct Bucket: Identifiable, Hashable, Codable, Equatable {
    
    
    //MARK: Main Variables
    var id: UUID
    var ownerId: String
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

extension Bucket {
    func withItems() async throws -> Bucket {
        var newBucket = self
        let bucketItems = try await FirebaseService.shared.getBucketItems(bucketId: self.id)
        newBucket.items = bucketItems
        return newBucket
    }
}

extension Bucket: FirebaseSafe {
    var dehydratedObject: Bucket {
        .init(id: id, ownerId: ownerId, title: title, date: date, description: description, headerImageUrl: headerImageUrl, color: color)
    }
}

extension Array where Element == Bucket {
    var items: [(Bucket, BucketItem)] {
        self
            .map{bucket in
                return bucket.items.map {item in
                    (bucket, item)
                }
            }
            .flatMap {combo -> [(Bucket, BucketItem)] in
                guard let combo else { return [] }
                return combo.1.map{(combo.0, $0)}
            }
    }
}
