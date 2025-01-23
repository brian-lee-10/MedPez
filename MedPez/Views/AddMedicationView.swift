import FirebaseAuth
import SwiftUI
import FirebaseFirestore

struct AddMedicationView: View {
    @State private var medicationName: String = ""
    @State private var quantity: String = ""
    @State private var dosage: String = ""
    @State private var selectedDays: [String] = []
    @State private var dailySchedule: [Date] = []
    @State private var notes: String = ""
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
    // Firebase Firestore reference
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            // Title
            Text("New Medicine")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 16)
            
            // Medication Name
            VStack(alignment: .leading){
                Text("Medication Name")
                TextField("Name", text: $medicationName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom, 8)
            }
            
            // Quantity and Dosage
            HStack {
                VStack(alignment: .leading) {
                    Text("Quantity")
                    TextField("Value", text: $quantity)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                VStack(alignment: .leading) {
                    Text("Dosage")
                    TextField("Value", text: $dosage)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
            
            // Repeat On Days
//            VStack(alignment: .leading) {
//                Text("Repeat on")
//                HStack {
//                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
//                        Button(action: {
//                            toggleDaySelection(day)
//                        }) {
//                            Text(day)
//                                .frame(width: 32, height: 32)
//                                .background(selectedDays.contains(day) ? Color.blue : Color(.systemGray6))
//                                .foregroundColor(selectedDays.contains(day) ? .white : .black)
//                                .cornerRadius(16)
//                        }
//                    }
//                }
//            }
//            .padding(.bottom, 16)
            
            // Daily Schedule
//            VStack(alignment: .leading) {
//                Text("Daily Schedule")
//                ForEach(dailySchedule, id: \.self) { time in
//                    HStack {
//                        Text(formatTime(time))
//                            .padding()
//                            .background(Color.green)
//                            .cornerRadius(8)
//                            .foregroundColor(.white)
//                        
//                        Spacer()
//                        Button(action: {
//                            // Add alarm or notification logic
//                        }) {
//                            Image(systemName: "bell.fill")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
//                .padding(.bottom, 8)
//                
//                Button(action: {
//                    addNewTime()
//                }) {
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                        Text("Add Time")
//                    }
//                }
//            }
//            .padding(.bottom, 16)
            
            // Notes
            TextField("Notes", text: $notes)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.bottom, 16)
            
            // Done Button
            Button(action: {
                validateAndSaveMedication()
            }) {
                Text("Add Medication")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                }
            }
        }
        .alert("Medication Logged", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your medication has been successfully added.")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Helper Functions
    
    private func toggleDaySelection(_ day: String) {
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
    }
    
    private func addNewTime() {
        dailySchedule.append(Date()) // Default to current time, let user edit
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func validateAndSaveMedication() {
        if medicationName.isEmpty {
            errorMessage = "Please enter the medication name."
            showErrorAlert = true
            return
        }
        
        if quantity.isEmpty {
            errorMessage = "Please enter the quantity."
            showErrorAlert = true
            return
        }
        
        if dosage.isEmpty {
            errorMessage = "Please enter the dosage."
            showErrorAlert = true
            return
        }
        
//        if selectedDays.isEmpty {
//            errorMessage = "Please select at least one day."
//            showErrorAlert = true
//            return
//        }
//        
//        if dailySchedule.isEmpty {
//            errorMessage = "Please add at least one schedule time."
//            showErrorAlert = true
//            return
//        }
        
        saveMedication()
    }
    
    private func saveMedication() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let medicationData: [String: Any] = [
            "name": medicationName,
            "quantity": quantity,
            "dosage": dosage,
            "days": selectedDays,
            "schedule": dailySchedule.map { $0.timeIntervalSince1970 }, // Store times as timestamps
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
        quantity = ""
        dosage = ""
        selectedDays = []
        dailySchedule = []
        notes = ""
    }
}

#Preview {
    AddMedicationView()
}
