//
//  CreateBucketView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/12/23.
//

import SwiftUI
import PhotosUI

struct CreateBucketView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: CreateBucketViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            //only show x if there is text and remove text on button click
            if !viewModel.title.isEmpty || !viewModel.description.isEmpty {
                Button(action: {
                    viewModel.title = ""
                    viewModel.description = ""
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.gray)
                })
            }
            
            TextField("Name your bucket...", text: $viewModel.title, axis: .vertical)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Describe your bucket...", text: $viewModel.description, axis: .vertical)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let image = viewModel.headerImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 80)
                        .clipped()
                } else {
                    Spacer()
                    HStack {
                        
                        Image(systemName: "photo")
                        
                        Text("Select a photo")
                        
                    }
                    .padding(.horizontal)
                    .frame(width: 200, height: 35)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
            
            Button(action: {
                Task { 
                    try await viewModel.uploadBucket()
                    dismiss()
                }
            }, label: {
                Text("SAVE")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "398378"))
                    .cornerRadius(10)
            })
            //make post button light color if no text
            .opacity(viewModel.title.isEmpty ? 0.5 : 1.0)
            //disable post button if no text
            .disabled(viewModel.title.isEmpty)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            
            Spacer()
        }
        .font(.footnote)
        .navigationTitle("Create a Bucket")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.subheadline)
                .foregroundColor(.red)
            }
        }
        .padding()
    }
}
