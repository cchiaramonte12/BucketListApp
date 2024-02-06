//
//  User.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/16/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let username: String
}
