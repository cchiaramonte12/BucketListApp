//
//  NavigationPathContainer.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI

class NavigationPathContainer: ObservableObject {
    @Published var path: NavigationPath = .init()
}
