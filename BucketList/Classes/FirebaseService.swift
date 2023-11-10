//
//  FirebaseService.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/28/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import Combine
import FirebaseStorage
import SwiftUI
import MapKit

class FirebaseService: ObservableObject {
    private init() { }
    static let shared = FirebaseService()
    
    func uploadBucket(_ bucket: Bucket) async throws {
        guard let reference = FirebasePaths.createBucket(bucket: bucket).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        try FirebaseService.pushObjectToDocument(docref: reference,
                                                 object: bucket)
    }
    
    func uploadItemIntoBucket(item: BucketItem, bucketID: UUID) async throws {
        guard let reference = FirebasePaths.createBucketItemInBucket(bucketID: bucketID, bucketItem: item).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        try FirebaseService.pushObjectToDocument(docref: reference,
                                                 object: item)
    }
    
    
    func getBucket(id: UUID) async throws -> Bucket {
        guard let reference = FirebasePaths.getBucket(id: id).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return try await FirebaseService.documentToObject(reference: reference,
                                                          type: Bucket.self)
        
    }
    
    func getBucketItem(bucketId: UUID, bucketItemId: UUID) async throws -> BucketItem {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketId, bucketItemId: bucketItemId).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return try await FirebaseService.documentToObject(reference: reference, type: BucketItem.self)
    }
    
    func getBuckets() async throws -> [Bucket] {
        guard let reference = FirebasePaths.getAllBuckets.collectionReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return try await FirebaseService.collectionToObjects(reference: reference,
                                                             type: Bucket.self)
        
    }
    
    func getBucketItems(bucketId: UUID) async throws -> [BucketItem]{
        guard let reference = FirebasePaths.getAllBucketsItemsFor(bucketID: bucketId).collectionReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return try await FirebaseService.collectionToObjects(reference: reference,
                                                             type: BucketItem.self)
        
    }
    
    func deleteBucket(id: UUID) async throws {
        guard let reference = FirebasePaths.getBucket(id: id).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        try await FirebaseService.deleteDocument(documentReference: reference)
        
        let itemsReference = FirebasePaths.getAllBucketsItemsFor(bucketID: id).collectionReference
        guard itemsReference != nil else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        do {
            let documents = try await itemsReference!.getDocuments()
            for document in documents.documents {
                try await FirebaseService.deleteDocument(documentReference: document.reference)
            }
        } catch {
            throw error
        }
    }
    
    
    func deleteBucketItem(bucketID: UUID, itemID: UUID) async throws {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        try await FirebaseService.deleteDocument(documentReference: reference)
    }
    
    func completeBucketItem(bucketID: UUID, itemID: UUID, isCompleted: Bool) async throws -> Result<Bool, any Error> {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "isCompleted", value: isCompleted)
    }
    
    func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/bucket_images/\(filename)")
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func updateBucketHeaderImage(withImageUrl imageUrl: String, bucketID: UUID) async throws -> Result<String, any Error> {
        guard let reference = FirebasePaths.getBucket(id: bucketID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "headerImageUrl", value: imageUrl)
    }
    
    func uploadColor(color: String, bucketID: UUID) async throws -> Result<String, any Error> {
        guard let reference = FirebasePaths.getBucket(id: bucketID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "color", value: color)
    }
    
    func uploadLocationName(bucketID: UUID, itemID: UUID, name: String) async throws -> Result<String, any Error> {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "locationName", value: name)
    }
    
    func uploadLocationAddress(bucketID: UUID, itemID: UUID, address: String) async throws -> Result<String, any Error> {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "locationAddress", value: address)
    }
    
    func uploadLocationLongitude(bucketID: UUID, itemID: UUID, longitude: CLLocationDegrees) async throws -> Result<CLLocationDegrees, any Error> {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "longitude", value: longitude)
    }
    
    func uploadLocationLatitude(bucketID: UUID, itemID: UUID, latitude: CLLocationDegrees) async throws -> Result<CLLocationDegrees, any Error> {
        guard let reference = FirebasePaths.getBucketItem(bucketId: bucketID, bucketItemId: itemID).documentReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        return await FirebaseService.updateFieldOnDocument(docref: reference, field: "latitude", value: latitude)
    }
    
}

extension FirebaseService {
    fileprivate static func documentToObject<T: Codable>(reference: DocumentReference, type: T.Type) async throws -> T {
        try await reference.getDocument(as: T.self)
    }
    
    fileprivate static func collectionToObjects<T: Codable>(reference: CollectionReference, type: T.Type) async throws -> [T] {
        let documents = try await reference.getDocuments()
        let objects = try documents.documents.map {document in
            try document.data(as: T.self)
        }
        
        return objects
    }
    
    fileprivate static func updateFieldOnDocument<C: Codable>(docref: DocumentReference, field: String, value: C) async -> Result<C, Error> {
            do {
                try await docref.setData([field : value], merge: true)
                return .success(value)
            } catch {
                return .failure(error)
            }
        }
    
    fileprivate static func pushObjectToDocument<T: FirebaseSafe>(docref: DocumentReference, object: T) throws {
        try docref.setData(from: object.dehydratedObject, merge: true)
    }
    
    fileprivate static func deleteDocument(documentReference: DocumentReference) async throws {
        try await documentReference.delete()
    }
}


enum FirebasePaths {
    
    //Document Paths
    case createBucket(bucket: Bucket)
    case createBucketItemInBucket(bucketID: UUID, bucketItem: BucketItem)
    case getBucket(id: UUID)
    case getBucketItem(bucketId: UUID, bucketItemId: UUID)
    // case delBucket(id: UUID)
    // case delItem(bucketId: UUID)
    
    //Collection Paths
    case getAllBuckets
    case getAllBucketsItemsFor(bucketID: UUID)
    
    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        
        db.settings = settings
        switch self {
        case .createBucket(let bucket):
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .document(bucket.id.uuidString)
                .self
        case .getBucket(let id):
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .document(id.uuidString)
                .self
        case .createBucketItemInBucket(let bucketID, let bucketItem):
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .document(bucketID.uuidString)
                .collection(FirebasePaths.FirebasePathComponent.bucketItems.rawValue)
                .document(bucketItem.id.uuidString)
                .self
        case .getBucketItem(let bucketId, let bucketItemId):
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .document(bucketId.uuidString)
                .collection(FirebasePaths.FirebasePathComponent.bucketItems.rawValue)
                .document(bucketItemId.uuidString)
                .self
            
        default:
            return nil
            
        }
    }
    
    var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        
        db.settings = settings
        switch self {
        case .getAllBuckets:
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .self
        case .getAllBucketsItemsFor(let bucketID):
            return db.collection(FirebasePaths.FirebasePathComponent.buckets.rawValue)
                .document(bucketID.uuidString)
                .collection(FirebasePaths.FirebasePathComponent.bucketItems.rawValue)
                .self
            
        default:
            return nil
            
        }
        
    }
}

extension FirebasePaths {
    enum FirebasePathComponent: String {
        case buckets
        case bucketItems
    }
}
