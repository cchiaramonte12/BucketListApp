//
//  TapButton.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 2/5/24.
//

import SwiftUI

struct TapButton<V: View>: View {
    var action: () -> Void
    @ViewBuilder var content: () -> V
    
    var body: some View {
        content()
            .onTapGesture {
                action()
            }
    }
}
