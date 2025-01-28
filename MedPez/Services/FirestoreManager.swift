//
//  FirestoreManager.swift
//  MedPez
//
//  Created by Brian Lee on 1/14/25.
//

import FirebaseFirestore
import FirebaseAuth

struct FirestoreManager {
    static func saveMedication(name: String, dosage: String, schedule: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let medicationData = [
            "name": name,
            "dosage": dosage,
            "schedule": schedule
        ]
        
        db.collection("users").document(userId).collection("medications").addDocument(data: medicationData) { error in
            if let error = error {
                print("Error saving medication: \(error.localizedDescription)")
            } else {
                print("Medication saved successfully!")
            }
        }
    }
}


extension FirestoreManager {
    static func fetchMedications(completion: @escaping ([Medication]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("medications").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching medications: \(error.localizedDescription)")
                completion([])
                return
            }
            
            let medications = snapshot?.documents.compactMap { doc -> Medication? in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let dosage = data["dosage"] as? String,
                      let schedule = data["schedule"] as? String else { return nil }
                return Medication(id: doc.documentID, name: name, dosage: dosage, schedule: schedule)
            } ?? []
            
            completion(medications)
        }
    }
}
