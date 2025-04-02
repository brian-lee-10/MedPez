//
//  MedicationViewModel.swift
//  MedPez
//
//  Created by Brian Lee on 4/2/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class MedicationViewModel: ObservableObject {
    @Published var medications: [MedicationTask] = []  // Stores fetched data
    private let db = Firestore.firestore()

    func fetchMedications() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        db.collection("users").document(userId).collection("medications")
            .order(by: "creationDate", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching medications: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                
                DispatchQueue.main.async {
                    self.medications = documents.compactMap { doc in
                        MedicationTask(id: doc.documentID, data: doc.data())
                    }
                }
            }
    }
}
