//
//  MapViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/2/23.
//

import Foundation
import MapKit

class MapViewModel: ViewModel {
    
    var title: String { "Map" }
    
    @Published var buckets: [Bucket]?
    
    init() {
        refresh()
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
//    var items: [(item: BucketItem, lat: Float, long: Float)] {
//        let validItems = buckets?.items.compactMap {item -> (item: BucketItem, lat: Float, long: Float)? in
//            guard let lat = item.latitude,
//                  let long = item.longitude else { return nil }
//                    return (item, lat, long)
//        }
//        
//        return validItems ?? []
//    }
//    
    var items: [BucketItem] {
        buckets?.items ?? []
    }
    
    func asyncRefresh() async {
        do {
            let buckets = try await FirebaseService.shared.getBuckets()
//            var itemsArray: [[BucketItem]] = []
//
//            for bucket in buckets {
//                let items = try await FirebaseService.shared.getBucketItems(bucketId: bucket.id)
//                itemsArray.append(items)
//            }
            
            await MainActor.run {
                self.buckets = buckets
//                self.items = items
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
