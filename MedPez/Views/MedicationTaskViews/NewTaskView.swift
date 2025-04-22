//
//  NewTaskView.swift
//  MedPez
//
//  Created by Brian Lee on 2/20/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewTaskView: View {
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    /// Model Content For Saving Data
    @Environment(\.modelContext) private var context
    
    
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "TaskColor 1"
    // @State private var taskDosage: String = ""
    @State private var taskComplete: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            /// Medication Name Field
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Medication Name")
                    .font(.custom("OpenSans-Bold", size:16))
                    .foregroundStyle(.black)
                
                TextField("Enter Medication Name...", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            /// Dosage and Frequency Fields
//            HStack(spacing: 12) {
//                VStack(alignment: .leading, spacing: 8, content: {
//                    Text("Dosage")
//                        .font(.custom("OpenSans-Bold", size:16))
//                        .foregroundStyle(.black)
//                    
//                    TextField("Enter Dosage...", text: $taskDosage)
//                        .keyboardType(.decimalPad)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 15)
//                        .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
//                })
//                /// Giving Some Space for tapping
//                .padding(.trailing, -15)
//            }
            
            /// Date and Task Color
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Date")
                        .font(.custom("OpenSans-Bold", size:16))
                        .foregroundStyle(.black)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                /// Giving Some Space for tapping
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.custom("OpenSans-Regular", size:16))
                        .foregroundStyle(.gray)
                    
                    let colors: [String] = (1...5).compactMap {index -> String in
                        return "TaskColor \(index)"
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 20, height: 20)
                                .background(content: {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                })
                
            }
            .padding(.top, 5)
            
            Spacer(minLength: 0)
            
            Button(action: {
                /// Saving Data
                let task = Task(taskTitle: taskTitle, creationDate: taskDate, tint: taskColor)
                do {
                    context.insert(task)
                    try context.save()
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Add Medication")
                    .font(.custom("OpenSans-Bold", size: 22))
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color(taskColor), in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
            
            
        })
        .padding(15)
    }
    
//    private func saveMedicationFirebase() {
//        let db = Firestore.firestore()
//        
//        guard let userId = Auth.auth().currentUser?.uid else {
//            print("User not authenticated")
//            return
//        }
//        
//        let taskData: [String: Any] = [
//            "taskTitle": taskTitle,
//            "taskDate": Timestamp(date: taskDate),
//            "tint": taskColor,
//            "dosage": taskDosage,
//            "taskComplete": taskComplete
//        ]
//        
//        db.collection("users")
//            .document(userId)
//            .collection("medications")
//            .addDocument(data: taskData) { error in
//                if let error = error {
//                    print("Error saving to Firestore: \(error.localizedDescription)")
//                } else {
//                    print("Successfully saved to Firestore!")
//                    dismiss()
//                }
//            }
//    }

}

#Preview {
    NewTaskView()
        .vSpacing(.bottom)
}

