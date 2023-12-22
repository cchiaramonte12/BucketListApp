//
//  HomeView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    @State private var showAlert = false
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if let buckets = viewModel.buckets {
                            if !buckets.isEmpty {
                                ForEach(buckets) { bucket in
                                    ZStack {
                                        NavigationLink(value: NavigationDestination.bucketView(id: bucket.id, bucket: bucket)) {
                                            BucketCardView(viewModel: BucketCardViewModel(bucket: bucket))
                                        }
                                    }
                                }
                            } else {
                                NoBucketsView()
                            }
                        } else {
                            VStack {
                                Button(action: {
                                    print(viewModel.currentUser)
                                }, label: {
                                    Text("Test")
                                })
                                ProgressView {
                                    Text("Loading Buckets")
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.asyncRefresh()
                }
                SheetButton {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color(hex: "398378"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                } content: { _ in
                    CreateBucketView(viewModel: .init())
                        .onDisappear() {
                            viewModel.refresh()
                        }
                }
                .padding()
            }
        }
    }
}
