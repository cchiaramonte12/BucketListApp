//
//  AddItemViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/20/23.
//

import Combine
import Firebase
import FirebaseFirestoreSwift

class AddItemViewModel: ObservableObject {

    @Published var title = ""
    @Published var isCompleted = false
    
}
