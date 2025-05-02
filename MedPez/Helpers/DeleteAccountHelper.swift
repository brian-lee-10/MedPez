//
//  DeleteAccountHelper.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DeleteAccountHelper {
    static func deleteUserAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not signed in."])));
            return
        }

        let userId = user.uid
        let db = Firestore.firestore()

        // Step 1: Delete Firestore document
        db.collection("users").document(userId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Step 2: Delete Firebase Auth account
            user.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
