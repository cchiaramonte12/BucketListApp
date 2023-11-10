//
//  AddItemView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/16/23.
//

import SwiftUI
import MapKit

struct AddItemView: View {
    
    let bucketId: UUID
    
    let actionAfterAddedItem: () -> Void
    
    @State private var title = ""
    
    @State var returnedLocation = Location(mapItem: MKMapItem())
    
    @EnvironmentObject var locationManager: LocationManager
        
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                
                TextField("Name your item...", text: $title)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                NavigationLink(destination: AddLocationView(viewModel: AddLocationViewModel(), returnedLocation: $returnedLocation),
                               label: {
                    Text("Add a Location to this Item")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "398378"))
                        .frame(width: 352, height: 44)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                })
                
                Button(action: {
                    Task {
                        do {
                            try await FirebaseService.shared.uploadItemIntoBucket(item: .init(id: UUID(), title: title, isCompleted: false), bucketID: bucketId)
                            actionAfterAddedItem()
                            dismiss()
                        } catch {
                            print("failed to add item")
                            print(error.localizedDescription)
                        }
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
                
                Text("Returned Place: \nName: \(returnedLocation.name)\nAddr: \(returnedLocation.address) \nCoords: \(returnedLocation.latitude), \(returnedLocation.longitude)")
            }
            .padding(14)
        }
        .navigationTitle("Add an Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}
