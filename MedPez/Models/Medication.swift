//
//  Medication.swift
//  MedPez
//
//  Created by Brian Lee on 1/14/25.
//

import Foundation

//struct Medication: Identifiable {
//    var id: Strin String
//    var dosage: String
//    var schedule: String
//}

struct Medication {
    let name: String
    let dosage: String
    let frequency: String
    let startDate: Date
    let endDate: Date?
    let times: [Date] // Array of specific times per day
    let daysOfWeek: [Int] // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    let totalPills: String
    let remindersEnabled: Bool
    let notes: String?
}
