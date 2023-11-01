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
    @Published var headerImageUrl = ""
    @Published var items = [BucketItem]()
    @Published var id = UUID()
    
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
        self.uiImage = uiImage
        self.headerImage = Image(uiImage: uiImage)
    }
    
    func uploadBucket() async throws {
        let bucket = Bucket(id: UUID(), title: title, date: Date(), description: description, headerImageUrl: headerImageUrl.isEmpty ? nil : "", items: items)
        try await FirebaseService.shared.uploadBucket(bucket)
        try await updateHeaderImage(id: bucket.id)
    }
    
    private func updateHeaderImage(id: UUID) async throws {
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await FirebaseService.shared.uploadImage(image) else { return }
        do {
            let result = try await FirebaseService.shared.updateBucketHeaderImage(withImageUrl: imageUrl, bucketID: id)
            print(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
