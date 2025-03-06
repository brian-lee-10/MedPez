//
//  MedicationTask.swift
//  MedPez
//
//  Created by Brian Lee on 2/18/25.
//
import SwiftUI
import SwiftData

@Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    
    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
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

//var sampleTasks: [Task] = [
//    .init(taskTitle: "Med #1", creationDate: .updateHour(-1), isCompleted: true, tint: .taskColor1),
//    .init(taskTitle: "Med #2", creationDate: .updateHour(0), tint: .taskColor2),
//    .init(taskTitle: "Med #3", creationDate: .updateHour(5), tint: .taskColor3),
//    .init(taskTitle: "Med #4", creationDate: .updateHour(10), tint: .taskColor4),
//]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
