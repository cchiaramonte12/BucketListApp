//
//  ProfileView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    private var currentUser: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile Information")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentUser?.fullname ?? "")
                            .font(.title2)
                        
                        Text("Email: " + (currentUser?.email ?? ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Username: " + (currentUser?.username ?? ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Actions")) {
                    NavigationLink(destination: Text("edit profile")) {
                        Text("Edit Profile")
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: Text("settings")) {
                        Text("Settings")
                            .foregroundColor(.blue)
                    }
                    
                    Button {
                        AuthService.shared.signOut()
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("User Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}
