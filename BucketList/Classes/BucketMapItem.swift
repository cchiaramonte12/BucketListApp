//
//  BucketMapItem.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 2/5/24.
//

import MapKit

class BucketMapItem: Hashable, Equatable, Identifiable {
    static func == (lhs: BucketMapItem, rhs: BucketMapItem) -> Bool {
        lhs.bucketItem == rhs.bucketItem &&
        lhs.bucket == rhs.bucket &&
        lhs.mapItem == rhs.mapItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bucketItem)
        hasher.combine(bucket)
        hasher.combine(mapItem)
    }
    
    var id: ObjectIdentifier {
        mapItem.id
    }
    
    init(bucketItem: BucketItem,
         bucket: Bucket? = nil,
         placemark: MKPlacemark) {
        self.bucketItem = bucketItem
        self.bucket = bucket
        self.mapItem = .init(placemark: placemark)
    }
    
    var bucketItem: BucketItem
    var bucket: Bucket?
    var mapItem: MKMapItem
}

