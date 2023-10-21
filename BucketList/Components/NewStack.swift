//
//  NewStack.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI

struct NewStack<Content: View>: View {
    @StateObject var navigationPathContainer: NavigationPathContainer = .init()
    @ViewBuilder var content: (NavigationPathContainer) -> Content
    var body: some View {
        NavigationStack(path: $navigationPathContainer.path) {
            content(navigationPathContainer)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    DestinationView(destination: destination)
                }
        }.environmentObject(navigationPathContainer)
    }
}
