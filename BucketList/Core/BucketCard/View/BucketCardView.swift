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
                    if let image = bucket.headerImageURL {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().foregroundStyle(Color(.random))
                    }
                }
                .frame(height: 80)
                .clipped()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(bucket.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(Date(), style: .date)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    
                    if let description = bucket.description {
                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding([.bottom, .leading, .trailing])
        }
        .background(Color(.tertiarySystemFill))
        .cornerRadius(12)
        .padding([.bottom, .leading, .trailing])
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
