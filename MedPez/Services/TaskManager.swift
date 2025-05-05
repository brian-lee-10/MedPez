//
//  TaskManager.swift
//  MedPez
//
//  Created by Brian Lee on 5/5/25.
//

import FirebaseAuth
import FirebaseFirestore

struct TaskManager {
    static func fetchPendingTasks(completion: @escaping ([Task]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            completion([])
            return
        }

        let db = Firestore.firestore()
        let now = Timestamp(date: Date())

        db.collection("users")
            .document(userId)
            .collection("medications")
            .whereField("taskDate", isGreaterThan: now)
            .whereField("taskComplete", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching pending tasks: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let tasks = snapshot?.documents.compactMap { doc -> Task? in
                    let data = doc.data()
                    guard
                        let title = data["taskTitle"] as? String,
                        let timestamp = data["taskDate"] as? Timestamp,
                        let dosage = data["dosage"] as? String
                    else {
                        return nil
                    }

                    return Task(
                        taskTitle: title,
                        creationDate: timestamp.dateValue(),
                        isCompleted: false,
                        dosage: dosage,
                        firebaseId: doc.documentID
                    )
                } ?? []

                completion(tasks)
            }
    }
}
