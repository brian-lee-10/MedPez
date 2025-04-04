////
////  MedicationViewModel.swift
////  MedPez
////
////  Created by Brian Lee on 4/2/25.
////
//
//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//class TasksViewModel: ObservableObject {
//    @Published var tasks = [MedicationTask]()
//    private var db = Firestore.firestore()
//    private var listener: ListenerRegistration?
//    
//    func fetchTasks(for date: Date) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            print("User not authenticated")
//            return
//        }
//        
//        let calendar = Calendar.current
//        let startOfDate = calendar.startOfDay(for: date)
//        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
//        
//        listener = db.collection("users")
//            .document(userId)
//            .collection("medications")
//            .whereField("taskDate", isGreaterThanOrEqualTo: Timestamp(date: startOfDate))
//            .whereField("taskDate", isLessThan: Timestamp(date: endOfDate))
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Error fetching tasks: \(error.localizedDescription)")
//                    return
//                }
//                self.tasks = snapshot?.documents.compactMap { document in
//                    try? document.data(as: MedicationTask.self)
//                } ?? []
//            }
//    }
//    
//    func delete(task: MedicationTask) {
//        guard let userId = Auth.auth().currentUser?.uid,
//              let taskId = task.id else { return }
//        db.collection("users")
//            .document(userId)
//            .collection("medications")
//            .document(taskId)
//            .delete { error in
//                if let error = error {
//                    print("Error deleting task: \(error.localizedDescription)")
//                }
//            }
//    }
//    
//    func toggleTaskCompletion(_ task: MedicationTask) {
//        guard let userId = Auth.auth().currentUser?.uid,
//              let taskId = task.id else { return }
//        db.collection("users")
//            .document(userId)
//            .collection("medications")
//            .document(taskId)
//            .updateData(["isCompleted": !task.isCompleted]) { error in
//                if let error = error {
//                    print("Error updating task: \(error.localizedDescription)")
//                }
//            }
//    }
//    
//    deinit {
//        listener?.remove()
//    }
//}
