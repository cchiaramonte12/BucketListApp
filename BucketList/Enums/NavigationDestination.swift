//
//  NavigationDestination.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI

enum NavigationDestination: Hashable {
    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        lhs.equatableValue == rhs.equatableValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(equatableValue)
    }
    
    case bucketView(id: UUID, bucket: Bucket?)
    case home
    case profile
    case addItem(bucketId: UUID, actionAfterAddedItem: () -> Void)
    case createBucket
    case map
    
    var equatableValue: String {
        
        var stringParts: [String] {
            switch self {
            case .bucketView(let id, _):
                return ["bucketView", id.description]
            case .home:
                return ["home"]
            case .profile:
                return ["profile"]
            case .addItem(let bucketId, _):
                return ["addItem", bucketId.uuidString]
            case .createBucket:
                return ["createBucket"]
            case .map:
                return ["map"]
            }
        }
        
        return stringParts.joined(separator: ".")
    }
}
