//
//  NoBucketsView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/31/23.
//

import SwiftUI

struct NoBucketsView: View {
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("bucket-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 260, height: 120)
                .padding()
            
            Text("No Buckets")
                .fontWeight(.semibold)
                .padding(.bottom)
            
            Text("Create your first BucketList by tapping the + below!")
                .font(.footnote)
            
        }
        
    }
}

#Preview {
    NoBucketsView()
}
