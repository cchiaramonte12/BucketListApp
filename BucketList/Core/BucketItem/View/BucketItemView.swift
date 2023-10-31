//
//  BucketItemView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketItemView: View {
    
    @State var item: BucketItem
    
    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $item.isCompleted) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .toggleStyle(.item)
            }
            .cornerRadius(12)
        }
        .padding()
    }
}
