//
//  Optionalview.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 12/11/23.
//

import SwiftUI

public struct OptionalView<Value, Content: View>: View {
    public init(value: Value? = nil,
                @ViewBuilder content: @escaping (Value) -> Content,
                fallbackContent: (() -> AnyView)? = nil
    ) {
        self.value = value
        self.content = content
        self.fallbackContent = fallbackContent
    }
    
    public var value: Value?
    @ViewBuilder var content: (Value) -> Content
    public var fallbackContent: (() -> AnyView)?
    
    public var body: some View {
        if let value {
            content(value)
        } else {
            fallbackContent?()
        }
    }
}
