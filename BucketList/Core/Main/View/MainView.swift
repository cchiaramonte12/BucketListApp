//
//  MainView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

import Combine

class MainViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
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
        } else {
            LogInView(viewModel: .init())
        }
    }
}
