//
//  MainView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NewStack {_ in
                HomeView(viewModel: .init())
            }
            .tabItem { Label(
                title: { Text("Home") },
                icon: { Image(systemName: "house") }
            ) }
            
            NewStack { _ in
                MapView(viewModel: .init())
            }
            .tabItem { Label (
                title: { Text("Map") },
                icon: { Image(systemName: "map") }
                ) } 
            
            NewStack {_ in
               ProfileView()
            }
            .tabItem { Label(
                title: { Text("Profile") },
                icon: { Image(systemName: "person") }
            ) }
            
        }
    }
}
