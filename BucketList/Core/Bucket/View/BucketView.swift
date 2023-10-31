//
//  BucketView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketView: View {
    
    @StateObject var viewModel: BucketViewModel
    
    var body: some View {
        Group {
            if let bucket = viewModel.bucket {
                VStack(alignment: .leading, spacing: 4) {
                    Group {
                        if let image = bucket.headerImage {
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle().foregroundStyle(Color(uiColor: bucket.fallbackColor))
                        }
                    }
                    .frame(height: 150)
                    .clipped()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(bucket.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(Date(), style: .date)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            
                            if let description = bucket.description {
                                Text(description)
                                    .font(.subheadline)
                            }
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
                                    BucketItemView(item: item)
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
                        Text("Get started by adding a new bucket item above!")
                            .foregroundStyle(Color(.systemGray3))
                            .padding()
                    }
                }
            } else {
                ProgressView {
                    Text("Loading bucket")
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
