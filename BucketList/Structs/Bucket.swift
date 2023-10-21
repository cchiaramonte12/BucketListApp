//
//  Bucket.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import Foundation

struct Bucket: Hashable, Identifiable {
    var id = UUID()
    let title: String
    let date: String?
    let description: String?
    let headerImage: String?
    //let items: [BucketItem]
}

let bucket1 = Bucket(title: "Golf Courses", date: "May 11, 2023", description: "Golf courses that I want to play", headerImage: "golf")
let bucket2 = Bucket(title: "Fitness", date: "January 1, 2020", description: "Fitness goals I want to achieve", headerImage: "fitness")
let bucket3 = Bucket(title: "Concerts", date: "December 12, 2013", description: "Artists and venues that I want to see", headerImage: "concert")
let bucket4 = Bucket(title: "Travel Destinations", date: "August 1, 2023", description: "Places to see", headerImage: "travel")
let bucket5 = Bucket(title: "Skills", date: "October 24, 2029", description: "Skills to learn", headerImage: "skills")
