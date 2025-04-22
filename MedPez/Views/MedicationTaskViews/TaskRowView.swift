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
    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            /// Completion Circle
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
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

            /// Task Details & Delete Button
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        /// Title
                        Text(task.taskTitle)
                            .font(.custom("OpenSans-Bold", size: 18))
                            .foregroundStyle(.black)
                            .overlay(
                                task.isCompleted ? AnyView(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 2)
                                        .offset(y: 6)
                                ) : AnyView(EmptyView())
                            )

                        /// Time
                        Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                            .font(.custom("OpenSans-Regular", size: 11))
                            .foregroundStyle(.black)
                            .overlay(
                                task.isCompleted ? AnyView(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 2)
                                        .offset(y: 5)
                                ) : AnyView(EmptyView())
                            )
                    }

                    Spacer()

                    /// Delete Button with Confirmation
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .padding()
                            .background(Color.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                    }
                    .alert("Delete Medication?", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) {}
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
