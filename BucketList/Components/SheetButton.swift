//
//  SheetButton.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI

struct SheetButton<Label: View, Content: View>: View {
    
    @State var shown = false
    
    @ViewBuilder var label: () -> Label
    @ViewBuilder var content: (Binding<Bool>) -> Content
    
    var body: some View {
        Button {
            shown.toggle()
        } label: {
            label()
        }
        .sheet(isPresented: $shown, content: {
            NavigationView {
                content($shown)
            }
        })
    }
}
