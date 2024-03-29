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
    
    @State private var dummyColor: Color? = nil
    @State private var dummyString: String? = nil
    
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
            
            
//            TextField("Notes", text: .init($dummyString, replacingNilWith: ""))
            ColorPicker("Pick a Color", selection: $viewModel.color)
                .fontWeight(.semibold)
                .padding()
            
//            ColorPicker("Pick a Color -- Test", selection: .init($dummyColor, replacingNilWith: .black, setNilWhenProxyChosen: true))
//                .fontWeight(.semibold)
//                .padding()
            
            
//            OptionalColorPicker(boundColor: $dummyColor)
            Rectangle()
                .frame(height: 50)
                .foregroundColor(viewModel.color)
                .cornerRadius(20)
                .padding()
            
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

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value, setNilWhenProxyChosen: Bool = true) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy,
                setNilWhenProxyChosen { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}
