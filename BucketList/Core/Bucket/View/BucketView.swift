//
//  BucketView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketView: View {
    
    @StateObject var viewModel: BucketViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if let bucket = viewModel.bucket {
                VStack(alignment: .leading, spacing: 4) {
                    AsyncImage(url: URL(string: bucket.headerImageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        //ProgressView()
                        Rectangle().foregroundStyle(Color(.random))
                    }
                    .frame(height: 150)
                    .clipped()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(bucket.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(viewModel.bucket?.date ?? Date(), style: .date)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            
                            if let description = bucket.description {
                                Text(description)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Menu() {
                                Button(role: .destructive) {
                                    Task {
                                        do {
                                            try await FirebaseService.shared.deleteBucket(id: bucket.id)
                                            dismiss()
                                        } catch {
                                            print("failed to delete item")
                                            print(error.localizedDescription)
                                        }
                                    }
                                } label: {
                                    Label("Delete Bucket", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(Color(hex: "398378"))
                            }
                            //.offset(x: 155, y: 60)
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                    
                    NavigationLink(value: NavigationDestination.addItem(bucketId: viewModel.bucketId,
                                                                        actionAfterAddedItem: viewModel.refresh), label: {
                        Text("New Item")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 352, height: 44)
                            .background(Color(hex: "398378"))
                            .cornerRadius(8)
                    })
                    .padding([.bottom, .leading, .trailing])
                    if let items = bucket.items,
                       !items.isEmpty {
                        List {
                            ForEach(items) { item in
                                HStack {
                                    BucketItemView(viewModel: BucketItemViewModel(item: item, bucketId: viewModel.bucketId, bucketItemId: item.id))
                                        .swipeActions() {
                                            Button(role: .destructive) {
                                                Task {
                                                    await viewModel.deleteBucketItem(item: item)
                                                }
                                            } label: {
                                                Text("Delete")
                                            }
                                            
                                        }
                                }
                                .padding(.trailing)
                                
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Get started by adding a new Bucket List Item above!")
                                .foregroundStyle(Color(.systemGray3))
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                    }
                }
            } else {
                ProgressView {
                    Text("Loading Buckets")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.asyncRefresh()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        Spacer()
    }
}

func getRandomColor() -> UIColor {
    let red:CGFloat = CGFloat(drand48())
    let green:CGFloat = CGFloat(drand48())
    let blue:CGFloat = CGFloat(drand48())
    
    return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
}
