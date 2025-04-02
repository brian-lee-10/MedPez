//
//  MedicationTask.swift
//  MedPez
//
//  Created by Brian Lee on 2/18/25.
//
import SwiftUI
import SwiftData
import FirebaseFirestore

/// Swift Data Structure
@Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var medicationDate: Date
    var isCompleted: Bool
    var tint: String
    var dosage: String
    
    init(id: UUID = .init(), taskTitle: String, medicationDate: Date = .init(), isCompleted: Bool = false, tint: String, dosage: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.medicationDate = medicationDate
        self.isCompleted = isCompleted
        self.tint = tint
        self.dosage = dosage
    }
    
    var tintColor: Color {
        switch tint {
        case "TaskColor 1": return .taskColor1
        case "TaskColor 2": return .taskColor2
        case "TaskColor 3": return .taskColor3
        case "TaskColor 4": return .taskColor4
        case "TaskColor 5": return .taskColor5
        default: return .black
        }
    }
}

/// Firebase to Swift data structure
struct MedicationTask: Identifiable {
    var id: String  // Firestore document ID
    var taskTitle: String
    var medicationDate: Date
    var tint: String
    var dosage: String
    var taskComplete: Bool
    
    // Convert Firestore document into MedicationTask struct
    init?(id: String, data: [String: Any]) {
        self.id = id
        self.taskTitle = data["taskTitle"] as? String ?? "Untitled"
        self.tint = data["tint"] as? String ?? "TaskColor 1"
        self.dosage = data["dosage"] as? String ?? ""
        self.taskComplete = data["taskComplete"] as? Bool ?? false

        if let timestamp = data["creationDate"] as? Timestamp {
            self.medicationDate = timestamp.dateValue()
        } else {
            self.medicationDate = Date()
        }
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
