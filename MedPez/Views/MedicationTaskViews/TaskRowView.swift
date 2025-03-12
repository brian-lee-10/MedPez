//
//  TaskRowView.swift
//  MedPez
//
//  Created by Brian Lee on 2/20/25.
//
import SwiftUI

struct TaskRowView: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var context
    @State private var showDeleteConfirmation = false  // State to track delete alert

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay{
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }

            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        /// Task Title
                        Text(task.taskTitle)
                            .font(.custom("OpenSans-Bold", size: 18))
                            .foregroundStyle(.black)
                            .overlay(
                                task.isCompleted ? AnyView(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 3)
                                ) : AnyView(EmptyView())
                            )
                        
                        /// Date Label
                        Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                            .font(.custom("OpenSans-Bold", size: 12))
                            .foregroundStyle(.black)
                            .overlay(
                                task.isCompleted ? AnyView(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 3)
                                ) : AnyView(EmptyView())
                            )
                    }
                    Spacer()
                    
                    if !task.dosage.isEmpty {
                        Text("\(task.dosage) mg")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    /// **Delete Button with Confirmation**
                    Button(action: {
                        showDeleteConfirmation = true  // Show confirmation alert
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .padding()
                            .background(Color.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                    }
                    .alert("Delete Medication?", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            deleteTask()
                        }
                    } message: {
                        Text("Are you sure you want to delete this medication?")
                    }
                }
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .offset(y: -8)
        }
        .hSpacing(.leading)
    }

    /// Function to delete task
    private func deleteTask() {
        context.delete(task)
        try? context.save()
    }

    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
}




#Preview {
    LogView()
}
