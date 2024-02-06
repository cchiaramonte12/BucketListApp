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
    @Published var currentUser: User?
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    @Published var color: Color = Color.black
    @Published var headerImage: Image?
    
    private var uiImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        setupSubscribers()
    }
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.headerImage = Image(uiImage: uiImage)
    }
    
    func uploadBucket() async throws {
        guard let userId = currentUser?.id else {
            throw BucketListErrors.currentUserIdNil
        }

        let bucket = Bucket(id: UUID(),
                            ownerId: userId,
                            title: title,
                            date: Date(),
                            description: description,
                            headerImageUrl: headerImageUrl.isEmpty ? nil : "")
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
