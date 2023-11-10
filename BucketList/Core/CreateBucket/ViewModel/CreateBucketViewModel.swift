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
    @Published var id = UUID()
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    @Published var color: Color = Color.black
    
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
        let bucket = Bucket(id: UUID(), title: title, date: Date(), description: description, headerImageUrl: headerImageUrl.isEmpty ? nil : "")
        try await FirebaseService.shared.uploadBucket(bucket)
        try await updateHeaderImage(id: bucket.id)
        try await updateColor(id: bucket.id)
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
    
    private func updateColor(id: UUID) async throws {
        do {
            let res = try await FirebaseService.shared.uploadColor(color: color.toHex() ?? "398378", bucketID: id)
            print(res)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
