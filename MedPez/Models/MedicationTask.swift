//
//  MedicationTask.swift
//  MedPez
//
//  Created by Brian Lee on 2/18/25.
//
import SwiftUI
import SwiftData

/// Swift Data Structure
 @Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    // var tint: String
    var dosage: String
    // var numberOfPills: Int
    
    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, dosage: String/*, numberOfPills: Int = 0 , tint: String*/) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        // self.tint = tint
        self.dosage = dosage
        // self.numberOfPills = numberOfPills
    }
    
//    var tintColor: Color {
//        switch tint {
//        case "TaskColor 1": return .taskColor1
//        case "TaskColor 2": return .taskColor2
//        case "TaskColor 3": return .taskColor3
//        case "TaskColor 4": return .taskColor4
//        case "TaskColor 5": return .taskColor5
//        default: return .black
//        }
//    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}


