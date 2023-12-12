//
//  MapItemDetailsView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/2/23.
//

import SwiftUI
import MapKit

struct MapItemDetailsView: View {
    @Environment(\.dismiss) var dismiss
    var mapSelection: BucketMapItem
    @State private var lookAroundScene: MKLookAroundScene?
    var getDirections: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSelection.mapItem.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    OptionalView(value: mapSelection.bucket?.title) { value in
                        Text("Bucket: \(value)")
                    }
                    
                    Text(mapSelection.bucketItem.locationAddress ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                .padding(.top)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding([.horizontal, .top])
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene, allowsNavigation: true)
                    .frame(height: 175)
                    .cornerRadius(12)
                    .padding(.horizontal)
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            HStack(spacing: 24) {
                Button {
                    mapSelection.mapItem.openInMaps()
                } label: {
                    Text("Open In Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button {
                    getDirections()
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension MapItemDetailsView {
    func fetchLookAroundPreview() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: mapSelection.mapItem.placemark.coordinate)
            lookAroundScene = try? await request.scene
        }
    }
}
