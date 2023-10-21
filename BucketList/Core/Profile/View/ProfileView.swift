//
//  SettingsView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Form {
                Section {
                    NavigationLink {
                        Text("Next screen")
                    } label: {
                        // what you see on the screen
                        Text("Take me to the next screen")
                    }
                    Button {
                        AuthService.shared.signOut()
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                    
                } header: {
                    Text("This is a header")
                } footer: {
                    Text("This is a footer")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
