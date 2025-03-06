//
//  FirestoreManager.swift
//  MedPez
//
//  Created by Brian Lee on 1/14/25.
//

import FirebaseFirestore
import FirebaseAuth

struct FirestoreManager {
    static func saveMedication(medication: Medication) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        guard let totalPills = Int(medication.totalPills) else {
            print("Error: totalPills is not a valid number")
            return
        }
        
        let medicationData: [String: Any] = [
            "name": medication.name,
            "dosage": medication.dosage,
            "frequency": medication.frequency,
            "startDate": medication.startDate.timeIntervalSince1970,
            "endDate": medication.endDate?.timeIntervalSince1970 as Any,
            "times": medication.times.map { $0.timeIntervalSince1970 },
            "daysOfWeek": medication.daysOfWeek,
            "totalPills": totalPills,
            "remindersEnabled": medication.remindersEnabled,
            "notes": medication.notes as Any
        ]
        
        db.collection("users")
            .document(userId)
            .collection("medications")
            .addDocument(data: medicationData) { error in
                if let error = error {
                    print("Error saving medication: \(error.localizedDescription)")
                } else {
                    print("Medication saved successfully!")
                }
            }
    }
    
    static func fetchMedications(completion: @escaping ([Medication]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("medications")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching medications: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let medications = snapshot?.documents.compactMap { doc -> Medication? in
                    let data = doc.data()
                    
                    guard let name = data["name"] as? String,
                          let dosage = data["dosage"] as? String,
                          let frequency = data["frequency"] as? String,
                          let startDateTimestamp = data["startDate"] as? TimeInterval,
                          let timeTimestamps = data["times"] as? [TimeInterval],
                          let daysOfWeek = data["daysOfWeek"] as? [Int],
                          let totalPills = data["totalPills"] as? Int,
                          let remindersEnabled = data["remindersEnabled"] as? Bool else {
                        return nil
                    }
                    
                    let startDate = Date(timeIntervalSince1970: startDateTimestamp)
                    let endDate = (data["endDate"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) }
                    let times = timeTimestamps.map { Date(timeIntervalSince1970: $0) }
                    let notes = data["notes"] as? String
                    
                    return Medication(
                        name: name,
                        dosage: dosage,
                        frequency: frequency,
                        startDate: startDate,
                        endDate: endDate,
                        times: times,
                        daysOfWeek: daysOfWeek,
                        // totalPills: totalPills,
                        totalPills: String(totalPills),
                        remindersEnabled: remindersEnabled,
                        notes: notes
                    )
                } ?? []
                
                completion(medications)
            }
    }
}
