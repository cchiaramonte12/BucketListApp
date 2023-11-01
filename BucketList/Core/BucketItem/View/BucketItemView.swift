//
//  BucketItemView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct BucketItemView: View {
    
    @StateObject var viewModel: BucketItemViewModel
    
    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $viewModel.item.isCompleted) {
                    Text(viewModel.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .toggleStyle(.item)
                .onChange(of: viewModel.item.isCompleted) { oldValue, newValue in
                    Task {
                        await viewModel.completeItem(value: newValue)
                    }
                }
            }
            .cornerRadius(12)
        }
        .padding()
    }
}
