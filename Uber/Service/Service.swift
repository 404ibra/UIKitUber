//
//  Service.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 6.02.2024.
//

import Firebase

let firestore = Firestore.firestore()


struct Service {
    
    static let shared = Service()
    let currentId = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping (User) -> Void) {
        firestore.collection("Users").document(currentId ?? "").getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: Error was occured when fechUserData is running \(error)")
                return
            }
            if let snapshot = snapshot {
                guard let dictionary = snapshot.data() as? [String : Any] else { return }
                let user = User(dictionary: dictionary)
                completion(user)
            }
        }
    }
}

