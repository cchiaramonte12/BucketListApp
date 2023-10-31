//
//  ItemToggleStyle.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/18/23.
//

import SwiftUI

struct ItemToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
                .foregroundColor(configuration.isOn ? Color(hex: "398378") : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
            }
            configuration.label
        }
    }
}

extension ToggleStyle where Self == ItemToggleStyle {
  static var item: ItemToggleStyle {
    ItemToggleStyle()
  }
}
