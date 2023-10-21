//
//  BucketView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketCardView: View {
    
    let bucket: Bucket
    
    var body: some View {
        VStack {
            ZStack {
                Group {
                    if let image = bucket.headerImage {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().foregroundStyle(Color(.systemGray6))
                    }
                }
                    .frame(height: 80)
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(bucket.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    if let date = bucket.date {
                        Text(date)
                            .foregroundColor(.secondary)
                    }
                }
                if let description = bucket.description {
                    Text(description)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding([.bottom, .leading, .trailing])
        }
        .background(Color(.tertiarySystemFill))
        .cornerRadius(12)
        .padding([.bottom, .leading, .trailing])
    }
}

#Preview {
    BucketCardView(bucket: bucket1)
}
