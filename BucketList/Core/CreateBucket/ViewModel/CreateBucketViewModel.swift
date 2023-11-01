//
//  CreateBucketViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI
import Combine
import Foundation
import Firebase
import PhotosUI
import FirebaseStorage

class CreateBucketViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var description = ""
    @Published var headerImageURL = ""
    @Published var items = [BucketItem]()
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    @Published var headerImage: Image?
    
    private var uiImage: UIImage?
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.headerImage = Image(uiImage: uiImage)
    }
    
    func uploadBucket() async throws {
        let bucket = Bucket(id: UUID(), title: title, date: Date(), description: description, headerImageURL: headerImageURL.isEmpty ? nil : "", items: items)
        try await FirebaseService.shared.uploadBucket(bucket)
    }
}
