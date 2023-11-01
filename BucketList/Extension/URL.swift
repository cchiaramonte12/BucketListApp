//
//  URL.swift
//  BucketList
//
//  Created by Christopher Guirguis on 11/1/23.
//

import SwiftUI

extension URL {
    init?(string: String?) {
        guard let string,
              let url = URL(string: string, relativeTo: nil) else { return nil }
        self = url
    }
}
