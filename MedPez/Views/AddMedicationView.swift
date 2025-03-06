import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddMedicationView: View {
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var frequency: String = ""
    @State private var startDate = Date()
    @State private var endDate: Date? = nil
    @State private var times: [Date] = []
    @State private var selectedDays: [Int] = []
    @State private var totalPills: String = ""
    @State private var remindersEnabled: Bool = false
    @State private var notes: String = ""
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showSuccessAlert = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage", text: $dosage)
                    TextField("Frequency (e.g., Daily, Weekly)", text: $frequency)
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    Toggle("Has an End Date?", isOn: Binding(
                        get: { endDate != nil },
                        set: { newValue in endDate = newValue ? Date() : nil }
                    ))
                    
                    if endDate != nil {
                        DatePicker("End Date", selection: Binding(
                            get: { endDate ?? Date() },
                            set: { endDate = $0 }
                        ), displayedComponents: .date)
                    }
                }
                
                // Section(header: Text("Schedule")) {
                //     MultiDatePickerView(selectedTimes: $times)
                    
                //     MultiSelectDayView(selectedDays: $selectedDays)
                // }
                
                Section(header: Text("Additional Info")) {
                    TextField("Total Pills", text: $totalPills)
                        .keyboardType(.numberPad)
                    
                    Toggle("Enable Reminders", isOn: $remindersEnabled)
                    
                    TextField("Notes", text: $notes)
                }
                
                Section {
                    Button("Save Medication") {
                        validateAndSaveMedication()
                    }
                    .alert("Success", isPresented: $showSuccessAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Medication has been saved successfully.")
                    }
                    .alert("Error", isPresented: $showErrorAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage)
                    }
                }
            }
            .navigationTitle("Add Medication")
        }
    }
    
    private func validateAndSaveMedication() {
        if medicationName.isEmpty {
            errorMessage = "Please enter the medication name."
            showErrorAlert = true
            return
        }
        if dosage.isEmpty {
            errorMessage = "Please enter the dosage."
            showErrorAlert = true
            return
        }
        if frequency.isEmpty {
            errorMessage = "Please enter the frequency."
            showErrorAlert = true
            return
        }
        // if times.isEmpty {
        //     errorMessage = "Please select at least one time."
        //     showErrorAlert = true
        //     return
        // }
        // if selectedDays.isEmpty {
        //     errorMessage = "Please select at least one day."
        //     showErrorAlert = true
        //     return
        // }
//        if totalPills <= 0 {
//            errorMessage = "Please enter a valid total number of pills."
//            showErrorAlert = true
//            return
//        }
        
        saveMedication()
    }
    
    private func saveMedication() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let medicationData: [String: Any] = [
            "name": medicationName,
            "dosage": dosage,
            "frequency": frequency,
            "startDate": startDate.timeIntervalSince1970,
            "endDate": endDate?.timeIntervalSince1970 as Any,
            "times": times.map { $0.timeIntervalSince1970 },
            "daysOfWeek": selectedDays,
            "totalPills": totalPills,
            "remindersEnabled": remindersEnabled,
            "notes": notes
        ]
        
        db.collection("users")
            .document(userId)
            .collection("medications")
            .addDocument(data: medicationData) { error in
                if let error = error {
                    print("Error saving medication: \(error.localizedDescription)")
                } else {
                    clearFields()
                    showSuccessAlert = true
                }
            }
    }
    
    private func clearFields() {
        medicationName = ""
        dosage = ""
        frequency = ""
        startDate = Date()
        endDate = nil
        times = []
        selectedDays = []
        totalPills = ""
        remindersEnabled = false
        notes = ""
    }
}

// MARK: - Helper Views

struct MultiDatePickerView: View {
    @Binding var selectedTimes: [Date]
    
    var body: some View {
        VStack {
            ForEach(selectedTimes.indices, id: \.self) { index in
                DatePicker("Time \(index + 1)", selection: $selectedTimes[index], displayedComponents: .hourAndMinute)
            }
            Button("Add Time") {
                selectedTimes.append(Date())
            }
        }
    }
}

struct MultiSelectDayView: View {
    @Binding var selectedDays: [Int]
    
    let days = [
        (1, "Sun"), (2, "Mon"), (3, "Tue"), (4, "Wed"),
        (5, "Thu"), (6, "Fri"), (7, "Sat")
    ]
    
    var body: some View {
        HStack {
            ForEach(days, id: \.0) { day in
                Button(action: {
                    if selectedDays.contains(day.0) {
                        selectedDays.removeAll { $0 == day.0 }
                    } else {
                        selectedDays.append(day.0)
                    }
                }) {
                    Text(day.1)
                        .padding()
                        .background(selectedDays.contains(day.0) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

