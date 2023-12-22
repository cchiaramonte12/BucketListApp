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
    
    func getBuckets(for userId: String) async throws -> [Bucket] {
        guard let reference = FirebasePaths.getAllBuckets.collectionReference else {
            throw BucketListErrors.firebaseReferenceInvalid
        }
        
        let filters: [String: Any] = ["ownerId": userId]
        
        return try await FirebaseService.findDocuments(collectionReference: reference,
                                                       filters: filters)
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
    
    static func findDocuments<T: Codable>(collectionReference: CollectionReference,
                                          filters: [String: Any],
                                          limit: Int = 500) async throws -> [T] {
        let query: () async throws -> QuerySnapshot = {
            var filters = filters
            guard let firstKey = filters.keys.first,
                  let firstValue = filters.removeValue(forKey: firstKey) else { return collectionReference.limit(to: limit).getDocuments }
            
            
            let firstQuery = collectionReference.whereField(firstKey, isEqualTo: firstValue)
            
            return filters.reduce(into: firstQuery) { partialResult, nextValue in
                partialResult = partialResult.whereField(nextValue.key, isEqualTo: nextValue.value)
            }.limit(to: limit).getDocuments
        }()
        let snapshot = try await query()
        
        return snapshot.documents.compactMap{ try? $0.data(as: T.self) }
    }
    
    static func findDocuments<T: Codable>(collectionReference: CollectionReference,
                                          documentIDs: [String]) async throws -> [T] {
        guard !documentIDs.isEmpty else {
            print("No documentIDs in query - \(collectionReference.path)")
            return []
        }
        return try await collectionReference.whereField(FieldPath.documentID(), in: documentIDs).getDocuments().documents.compactMap{
            do {
                return try $0.data(as: T.self)
            } catch {
                print("Failed to unwrap \(T.self)", error)
                return nil
            }
        }
    }
    
}


enum FirebasePaths {
    
    //Document Paths
    case createBucket(bucket: Bucket)
    case createBucketItemInBucket(bucketID: UUID, bucketItem: BucketItem)
    case getBucket(id: UUID)
    case getBucketItem(bucketId: UUID, bucketItemId: UUID)
    case getBucketFromItem(bucketItemId: UUID)
    
    //Collection Paths
    case getAllBuckets
    case getAllBucketsItemsFor(bucketID: UUID)
    
    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
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
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
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

//static func documentToObject<T: Codable>(docref: DocumentReference, type: T.Type) async throws -> T {
//       let document = try await docref.getDocument()
//       let object = try document.data(as: T.self)
//       return object
//   }
//   
//   static func document(docref: DocumentReference) async throws -> DocumentSnapshot {
//       return try await docref.getDocument()
//   }
//   
//   static func findDocuments<T: Codable>(collectionReference: CollectionReference,
//                                                     filters: [String: Any],
//                                                     limit: Int = 500) async throws -> [T] {
//       let query: () async throws -> QuerySnapshot = {
//           var filters = filters
//           guard let firstKey = filters.keys.first,
//                 let firstValue = filters.removeValue(forKey: firstKey) else { return collectionReference.limit(to: limit).getDocuments }
//           
//           
//           let firstQuery = collectionReference.whereField(firstKey, isEqualTo: firstValue)
//           
//           return filters.reduce(into: firstQuery) { partialResult, nextValue in
//               partialResult = partialResult.whereField(nextValue.key, isEqualTo: nextValue.value)
//           }.limit(to: limit).getDocuments
//       }()
//       let snapshot = try await query()
//       
//       return snapshot.documents.compactMap{ try? $0.data(as: T.self) }
//   }
//   
//   static func findDocuments<T: Codable>(collectionReference: CollectionReference,
//                                                     documentIDs: [String]) async throws -> [T] {
//       guard !documentIDs.isEmpty else {
//           IMMIXLogger.Log.warning("No documentIDs in query - \(collectionReference.path)")
//           return []
//       }
//       return try await collectionReference.whereField(FieldPath.documentID(), in: documentIDs).getDocuments().documents.compactMap{
//           do {
//               return try $0.data(as: T.self)
//           } catch {
//               IMMIXLogger.Log.error("Failed to unwrap \(T.self)", error)
//               return nil
//           }
//       }
//   }
//   
//   @discardableResult  static func updateFieldOnDocument<C: Codable>(docref: DocumentReference, field: String, value: C) async throws -> C {
//       try await docref.updateData([field : value])
//       return value
//   }
//   
//   static func arrayUnionObject<C: Codable>(docref: DocumentReference, field: String, value: [C]) async throws  {
//       let data = try value.map {try Firestore.Encoder().encode($0) }
//       try await docref.updateData([field : FieldValue.arrayUnion(data)])
//   }
//   
//   static func arrayRemoveObject<C: Codable>(docref: DocumentReference, field: String, value: [C]) async throws  {
//       let data = try value.map {try Firestore.Encoder().encode($0) }
//       try await docref.updateData([field : FieldValue.arrayRemove(data)])
//   }
//   
//   static func arrayUnionString<C: Codable>(docref: DocumentReference, field: String, value: [C]) async throws  {
//       try await docref.updateData([field : FieldValue.arrayUnion(value)])
//   }
//   
//   static func arrayRemoveString<C: Codable>(docref: DocumentReference, field: String, value: [C]) async throws  {
//       try await docref.updateData([field : FieldValue.arrayRemove(value)])
//   }
//   
//   static func pushObjectToDocument<T: Codable>(docref: DocumentReference, object: T) throws {
//       try docref.setData(from: object, merge: true)
//   }

////
////  FirebaseService.swift
////  FlowPeak
////
////  Created by Christopher Guirguis on 10/22/23.
////
//
//import SwiftUI
//import Firebase
//import FirebaseAuth
//import FirebaseFirestoreSwift
//import FirebaseStorage
//import Combine
//import ImmixCore
//
//class FlowPeakFirebaseService: FirebaseService<FlowPeakUser, FirebasePaths> {
//    private override init() {
//        super.init()
//        if let user = Firebase.Auth.auth().currentUser {
//            self.setListenerForUser(id: user.uid)
//        } else {
//            print("user not logged in")
//        }
//    }
//    static let shared = FlowPeakFirebaseService()
//    
//    //MARK: Session Logs
//    func logSession(session: SessionDetails) throws {
//        if let userId = Firebase.Auth.auth().currentUser?.uid {
//            try Self.pushObjectToDocument(docref: FirebasePaths.logUserSession(userId: userId, session: session).documentReference, object: session)
//        } else {
//            try Self.pushObjectToDocument(docref: FirebasePaths.logCommonSession(session: session).documentReference, object: session)
//        }
//    }
//    
//    private func logCommonSession(session: SessionDetails) throws {
//        try Self.pushObjectToDocument(docref: FirebasePaths.logCommonSession(session: session).documentReference, object: session)
//    }
//    
//    private func logUserSession(userId: String, session: SessionDetails) throws {
//        try Self.pushObjectToDocument(docref: FirebasePaths.logCommonSession(session: session).documentReference, object: session)
//    }
//    
//    //MARK: Study Functions
//    func findStudy(code: Int) async throws -> [Study] {
//        let filters: [String: Any] = ["isAcceptingNewMembers": true,
//                       "uniqueCode": code]
//        return try await Self.findDocuments(collectionReference: FirebaseCollectionPaths.studies.collectionReference,
//                                                filters: filters)
//    }
//    
//    func joinStudy(user: FlowPeakUser, studyId: String) async throws {
//        guard let id = user.id else {
//            throw FlowPeakError.failedToJoinStudy
//        }
//        try await Self.arrayUnionString(docref: FirebasePaths.user(userId: id).documentReference, field: "joinedStudyIds", value: [studyId])
//        
//        do {
//            let document = try await Self.document(docref: FirebasePaths.joinUserAndStudy(userId: id, studyId: studyId).documentReference)
//            if document.exists,
//               var studyJoinDetailsHistory = try? document.data(as: StudyJoinDetails.self).history {
//                studyJoinDetailsHistory.append(.init(status: .joinedStudy, date: Date()))
//                
//                try await Self
//                    .arrayUnionObject(docref: FirebasePaths.joinUserAndStudy(userId: id, studyId: studyId).documentReference,
//                                               field: "history",
//                                               value: [StudyJoinDetails.JoinedInstanceDetails(status: .joinedStudy, date: Date())])
//            } else {
//                try Self.pushObjectToDocument(docref: FirebasePaths.joinUserAndStudy(userId: id, studyId: studyId).documentReference, object: StudyJoinDetails(studyId: studyId, history: [.init(status: .joinedStudy, date: Date())]))
//            }
//        } catch {
//            print(error)
//        }
//
//    }
//    
//    func leaveStudy(user: FlowPeakUser, studyId: String) async throws {
//        guard let id = user.id else {
//            throw FlowPeakError.failedToLeaveStudy
//        }
//        try await Self.arrayRemoveString(docref: FirebasePaths.user(userId: id).documentReference, field: "joinedStudyIds", value: [studyId])
//        
//        do {
//            let document = try await Self.document(docref: FirebasePaths.joinUserAndStudy(userId: id, studyId: studyId).documentReference)
//            if document.exists {
//                try await Self
//                    .arrayUnionObject(docref: FirebasePaths.joinUserAndStudy(userId: id, studyId: studyId).documentReference,
//                                               field: "history",
//                                               value: [StudyJoinDetails.JoinedInstanceDetails(status: .leftStudy, date: Date())])
//            }
//        }
//        
//    }
//    
//    func getAllStudiesCurrentUserIsAPartOf(user: FlowPeakUser) async throws -> [StudyJoinDetails] {
//        guard let id = user.id else {
//            throw FlowPeakError.failedToJoinStudy
//        }
//        
//        //First get IDs for joined studies
//        let studyJoinIDs = try await Self.fetchUser(id: id).joinedStudyIds
//        
//        guard let studyJoinIDs,
//              !studyJoinIDs.isEmpty else {
//            return []
//        }
//        
//        ///Then I get the details of the studies they joined
//#warning("ENHANCEMENT: need to just grab the ones they are a part of")
//        let allDetailsInHistory: [String:StudyJoinDetails] = try await Self
//            .findDocuments(
//                collectionReference: FirebaseCollectionPaths.studiesUserJoined(userId: id).collectionReference,
//                filters: [:])
//            .toDictionary(keyField: \.id)
//        
//        ///Next I iterate through the IDs and grab all details objects that were releevant
//        var studyDetailsForCurrentJoinedStudies = studyJoinIDs.compactMap{ allDetailsInHistory[$0] }
//        
//        ///Then get a list of all the studyObjects that were part of the studies we've joined
//        let fullStudyObjects: [Study] = try await Self
//            .findDocuments(collectionReference: FirebaseCollectionPaths.studies.collectionReference,
//                           documentIDs: studyJoinIDs)
//            
//        
//        let hydratedStudies = studyDetailsForCurrentJoinedStudies.hydrateOneToOne(keyToHydrate: \.fullStudy,
//                                                    referenceKey: \.studyId,
//                                                    crossReferenceValues: fullStudyObjects,
//                                                                          crossReferenceKey: \.id)
//        return hydratedStudies
//        
//    }
//    
//    func hydrateAndPostUser(user: FlowPeakUser) async throws {
//        var thisUser = user
//        
//        var studies = try await self.getAllStudiesCurrentUserIsAPartOf(user: thisUser)
//        
//        let surveyIds = studies.flatMap{$0.fullStudy?.associatedSurveyIDs ?? [] }
//        
//        if !surveyIds.isEmpty {
//            
//            let surveys: [Survey] = try await Self
//                .findDocuments(collectionReference: FirebaseCollectionPaths.surveys.collectionReference,
//                               documentIDs: surveyIds)
//            
//            for item in studies.enumerated() {
//                let study = item.element
//                let associatedSurveys = surveys.filter { study.fullStudy?.associatedAdjuncts?.surveys.map{$0.adjunctId}.contains($0.id) == true }
//                studies[item.offset].fullStudy?.surveys = associatedSurveys
//            }
//            
//            thisUser.joinedStudies = studies
//        }
//        
//        let nonMutableUser = thisUser
//        
//        print("Fetched Updated User: \(nonMutableUser.fullName ?? "nil") - From Listener - hydrated their (\(studies.count)) studies")
//        
//        await MainActor.run {
//            self.passthroughUser.send(nonMutableUser)
//        }
//    }
//    
//    func finishSettingUpLogin(`for` user: User) async throws {
//        setListenerForUser(id: user.uid)
//        let flowPeakUser = try await Self.fetchUser(id: user.uid)
//        passthroughUser.send(flowPeakUser)
//    }
//    
//    func finishSignUp(with authResult: AuthDataResult,
//                      firstName: String,
//                      middleName: String?,
//                      lastName: String) async throws {
//        
//        let id = authResult.user.uid
//        
//        let newBlankUser = FlowPeakUser(id: id,
//                                    firstName: firstName,
//                                    middleName: middleName,
//                                    lastName: lastName)
//        
//        try self.updateUser(id: id, user: newBlankUser)
//        try await finishSettingUpLogin(for: authResult.user)
//    }
//    
//    override func setListenerForUser(id: String) {
//        let userListener = FirebasePaths.user(userId: id).documentReference
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                Task {
//                    do {
//                        let thisUser = try document.data(as: FlowPeakUser.self)
//                        try await self.hydrateAndPostUser(user: thisUser)
//                    } catch {
//                        print("Error processing snapshot (user) - \(error.localizedDescription)")
//                    }
//                }
//            }
//        
//        let studiesListener = FirebaseCollectionPaths.studiesUserJoined(userId: id).collectionReference.addSnapshotListener { collectionSnapshot, error in
//            guard let collection = collectionSnapshot else {
//                print("Error fetching collection: \(error!)")
//                return
//            }
//            do {
//                let objects = try collection.documents.compactMap{ try $0.data(as: StudyJoinDetails.self) }
//                var user = self.passthroughUser.value
//                user?.joinedStudies = objects
//                DispatchQueue.main.async {
//                    self.passthroughUser.send(user)
//                }
//            } catch {
//                print("Error processing snapshot (studiesUserJoined) - \(error.localizedDescription)")
//            }
//        }
//        
//        self.listeners.append(userListener)
//        self.listeners.append(studiesListener)
//    }
//    
//    func createSurvey() async throws {
//        try Self.pushObjectToDocument(docref: FirebasePaths.createSurvey(survey: .sgs6).documentReference, object: Survey.sgs6)
//    }
//}
//
////MARK: Storeage Functions
//extension FirebaseService {
//    static func saveAudio(from localURL: URL, storageLocation: FirebasePaths.StoragePaths) async throws -> StorageMetadata {
//        let audioData = try Data(contentsOf: localURL)
//        let storageReference = storageLocation.storageReference
//        let metadata = try await storageReference.putDataAsync(audioData)
//        return metadata
//    }
//}
//
//enum FirebasePaths: FirebasePathProtocol {
//    static func pathToUser(id: String) -> FirebasePaths {
//        .user(userId: id)
//    }
//    
//    case user(userId: String)
//    case logCommonSession(session: SessionDetails)
//    case logUserSession(userId: String, session: SessionDetails)
//    case createSurvey(survey: Survey)
//    case joinUserAndStudy(userId: String, studyId: String)
//    
//    var documentReference: DocumentReference {
//        let db = Firestore.firestore()
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
//        switch self {
//        case .logCommonSession(let sessionDetails):
//            return db.collection("users")
//                .document("common")
//                .collection("sessions")
//                .document(sessionDetails.id.uuidString).self
//        case .user(let userId):
//            return db
//                .collection("users")
//                .document(userId).self
//        case .logUserSession(let userId, let sessionDetails):
//            return db.collection("users")
//                .document(userId)
//                .collection("sessions")
//                .document(sessionDetails.id.uuidString).self
//        case .createSurvey(let survey):
//            return db.collection("surveys")
//                .document(survey.id)
//        case .joinUserAndStudy(let userId, let studyId):
//            return db.collection("users")
//                .document(userId)
//                .collection("joinedStudies")
//                .document(studyId).self
//        }
//    }
//}
//
//enum FirebaseCollectionPaths {
//    case studies
//    case surveys
//    case studiesUserJoined(userId: String)
//    
//    var collectionReference: CollectionReference {
//        
//        let db = Firestore.firestore()
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
//        switch self {
//        case .studies:
//            return db.collection("studies")
//        case .surveys:
//            return db.collection("surveys")
//        case .studiesUserJoined(let userId):
//            return db
//                .collection("users")
//                .document(userId)
//                .collection("joinedStudies")
//                .self
//        }
//    }
//}
//
//extension FirebasePaths {
//    enum StoragePaths {
//        case commonSessionsAudioFile(sessionDetails: SessionDetails)
//        
//        var storageReference: StorageReference {
//            // Create a root reference
//            let storageRef = Storage.storage().reference()
//            switch self {
//            case .commonSessionsAudioFile(let sessionDetails):
//                return storageRef.child("users/common/sessions/\(sessionDetails.id.uuidString)/audio.wav")
//            }
//        }
//    }
//}
//
//extension Array where Element: Hashable {
//    func firstIndexOf<E: Equatable>(where key: KeyPath<Element, E>, is comparedValue: E) -> Element? {
//        self.first(where: {$0[keyPath: key] == comparedValue})
//    }
//    
//    func firstIndexOf<E: Equatable>(where key: KeyPath<Element, E?>, is comparedValue: E) -> Element? {
//        self.first(where: {$0[keyPath: key] == comparedValue})
//    }
//}
//extension Array {
//    func toDictionary<H: Hashable>(keyField: KeyPath<Element, H>) -> [H: Element] {
//        return reduce(into: [:], { $0[$1[keyPath: keyField]] = $1 })
//    }
//
//    func toDictionary<H: Hashable>(keyField: KeyPath<Element, H?>) -> [H: Element] {
//        return reduce(into: [:]) { result, element in
//            if let key = element[keyPath: keyField] {
//                result[key] = element
//            }
//        }
//    }
//}
//
//protocol Hydratable { }
//
//extension Hydratable {
//    mutating func hydrate<Value>(key: WritableKeyPath<Self, Value>, value: Value) {
//        self[keyPath: key] = value
//    }
//}
//
//extension Array where Element: Hydratable {
//    func hydrateOneToOne<Value, CrossReferencingKeyValue: Equatable & Hashable>(keyToHydrate: WritableKeyPath<Element, Value?>,
//                                                                        referenceKey: KeyPath<Element, CrossReferencingKeyValue>,
//                                                                        crossReferenceValues: [Value],
//                                                                        crossReferenceKey: WritableKeyPath<Value, CrossReferencingKeyValue?>) -> [Element]{
//        var returnValues = self
//        let dictionary: [CrossReferencingKeyValue:Value] = crossReferenceValues.toDictionary(keyField: crossReferenceKey)
//        for item in returnValues.enumerated() {
//            let queryKey: CrossReferencingKeyValue = item.element[keyPath: referenceKey]
//            let foundValue: Value? = dictionary[queryKey]
//            returnValues[item.offset][keyPath: keyToHydrate] = foundValue
//        }
//        
//        return returnValues
//    }
//    
//    func hydrateManyToMany<Value, CrossReferencingKeyValue: Equatable & Hashable>(keyToHydrate: WritableKeyPath<Element, [Value]?>,
//                                                                        referenceKey: KeyPath<Element, [CrossReferencingKeyValue]>,
//                                                                        crossReferenceValues: [Value],
//                                                                        crossReferenceKey: WritableKeyPath<Value, CrossReferencingKeyValue?>) -> [Element] {
//        var returnValues = self
//        let dictionary: [CrossReferencingKeyValue:Value] = crossReferenceValues.toDictionary(keyField: crossReferenceKey)
//        for item in returnValues.enumerated() {
//            let queryKey: [CrossReferencingKeyValue] = item.element[keyPath: referenceKey]
//            let foundValues: [Value]? = {
//                let values = queryKey.compactMap { dictionary[$0] }
//                guard !values.isEmpty else { return nil }
//                return values
//            }()
//            returnValues[item.offset][keyPath: keyToHydrate] = foundValues
//        }
//        
//        return returnValues
//    }
//}

//
//  UltraGPTFirebaseService.swift
//  UltraGPT
//
//  Created by Christopher Guirguis on 12/17/23.
//
//
//import SwiftUI
//import ImmixGPT
//import ImmixCore
//import Firebase
//
//class UltraGPTFirebaseService: FirebaseService<UltraGPTUser, FirebasePaths> {
//    private override init() {
//        super.init()
//        if let user = Firebase.Auth.auth().currentUser {
//            self.setListenerForUser(id: user.uid)
//        } else {
//            print("user not logged in")
//        }
//    }
//    
//    static let shared = UltraGPTFirebaseService()
//    
//    func finishSettingUpLogin(`for` user: User) async throws {
//        setListenerForUser(id: user.uid)
//        let flowPeakUser = try await Self.fetchUser(id: user.uid)
//        passthroughUser.send(flowPeakUser)
//    }
//    
//    override func currentUserFetchPostProcessing(user: UltraGPTUser) async throws -> UltraGPTUser {
//        guard !user.accessGrantedModelIds.isEmpty else {
//            return user
//        }
//        var returnValue = user
//        let models: [UltraGPTModel] = try await Self
//            .findDocuments(collectionReference: FirebaseCollectionPaths.models.collectionReference,
//                           documentIDs: user.accessGrantedModelIds)
//        
//        returnValue.accessGrantedModels = models
//        
//        return returnValue
//    }
//    
//    func finishSignUp(with authResult: AuthDataResult,
//                      firstName: String,
//                      middleName: String?,
//                      lastName: String) async throws {
//        
//        let id = authResult.user.uid
//        
//        let newBlankUser = UltraGPTUser(id: id,
//                                        firstName: firstName,
//                                        middleName: middleName,
//                                        lastName: lastName,
//                                        accessGrantedModelIds: [])
//        
//        try self.updateUser(id: id, user: newBlankUser)
//        try await finishSettingUpLogin(for: authResult.user)
//    }
//    
//    func grantPermissionToUser(user userId: String, assistantId: String) async throws {
//        try await Self.arrayUnionString(docref: FirebasePaths.user(userId: userId).documentReference,
//                              field: "accessGrantedModelIds",
//                              value: [assistantId])
//    }
//    
//    func createModel(model: UltraGPTModel) async throws {
//        try Self.pushObjectToDocument(docref: FirebasePaths.model(modelId: model.id).documentReference, object: model)
//    }
//    
//    func createConversation(conversation: UltraGPTConversation) async throws {
//        try Self.pushObjectToDocument(docref: FirebasePaths.conversation(conversationId: conversation.id).documentReference, object: conversation)
//    }
//    
//    func fetchConversations(ownerId: String,
//                      modelId: String) async throws -> [UltraGPTConversation] {
//        let filters: [String: Any] = ["ownerId": ownerId,
//                                      "modelId": modelId]
//        return try await Self.findDocuments(collectionReference: FirebaseCollectionPaths.conversations.collectionReference,
//                                            filters: filters)
//    }
//}
//
//
//enum FirebsePathComponents {
//    typealias RawValue = String
//    
//    case users
//    case models
//    case custom(String)
//    
//    var string: RawValue {
//        switch self {
//        case .users:
//            return "users"
//        case .models:
//            return "models"
//        case .custom(let string):
//            return string
//        }
//    }
//    
//}
//
//enum FirebaseCollectionPaths {
//    
//    case models
//    case conversations
//    
//    var collectionReference: CollectionReference {
//        let db = Firestore.firestore()
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
//        switch self {
//        case .models:
//            return db
//                .collection("models").self
//        case .conversations:
//            return db
//                .collection("conversations").self
//        }
//    }
//}
//
//enum FirebasePaths: FirebasePathProtocol {
//    static func pathToUser(id: String) -> FirebasePaths {
//        .user(userId: id)
//    }
//    
//    case user(userId: String)
//    case model(modelId: String)
//    case conversation(conversationId: String)
//    
//    var documentReference: DocumentReference {
//        let db = Firestore.firestore()
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        
//        db.settings = settings
//        switch self {
//        case .user(let userId):
//            return db
//                .collection("users")
//                .document(userId).self
//        case .model(let modelId):
//            return db
//                .collection("models")
//                .document(modelId).self
//        case .conversation(let conversationId):
//            return db
//                .collection("conversations")
//                .document(conversationId).self
//        }
//    }
//}
