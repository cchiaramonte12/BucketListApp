//
//  ContentView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    //@EnvironmentObject var appState: AppState
    
    var body: some View {
        MainView()
    }
}
