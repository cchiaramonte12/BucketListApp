//
//  OptionalColorPicker.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 2/5/24.
//

import SwiftUI

struct OptionalColorPicker: View {
    
    init(boundColor: Binding<Color?>,
         defaultColor: Color = .black) {
        self.color = boundColor.wrappedValue ?? defaultColor
        _boundColor = boundColor
    }
    
    @Binding var boundColor: Color?
    @State var color: Color
    var body: some View {
        ColorPicker("Some Title", selection: $color)
            .onChange(of: color) {
                self.boundColor = color
            }
    }
}
