//
//  CancelDirectionsView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 12/12/23.
//

import SwiftUI

struct CancelDirectionsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var cancelDirections: () -> ()
    
    var body: some View {
        VStack {
            Text("Cancel Directions")
                .font(.subheadline.weight(.semibold))
            
            Button(action: {
                cancelDirections()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(Color(.red))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            })
        }
    }
}
