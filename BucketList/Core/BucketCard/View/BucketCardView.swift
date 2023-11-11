//
//  BucketView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketCardView: View {
    
    @StateObject var viewModel: BucketCardViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Group {
                    AsyncImage(url: URL(string: viewModel.bucket.headerImageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle().foregroundStyle(Color(hex: viewModel.bucket.color ?? "398378"))
                    }
                    .frame(height: 100)
                    .clipped()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.bucket.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(viewModel.bucket.date, style: .date)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    
                    if let description = viewModel.bucket.description {
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
