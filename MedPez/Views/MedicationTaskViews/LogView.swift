//
//  LogView.swift
//  MedPez
//
//  Created by Brian Lee on 2/18/25.
//

import SwiftUI

struct LogView: View {
    /// Medication Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    /// Animation Namespace
    @Namespace private var animation
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0, content: {
            HeaderView()
            
            ScrollView(.vertical) {
                VStack {
                    /// Tasks View
                    TasksView(currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(Color("SlateBlue"), in: .circle)
            })
            .padding(15)
        })
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
    
        .sheet(isPresented: $createNewTask, content: {
            NewTaskView()
                .presentationDetents([.height(430)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.BG)
        })
    }
        
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                // Text fields aligned to the leading edge
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentDate.formatted(.dateTime.weekday(.wide)))
                        .font(.custom("OpenSans-Bold", size: 30))
                        .foregroundStyle(Color("SlateBlue"))
                    
                    Text(currentDate.formatted(.dateTime.month().day().year()))
                        .font(.custom("OpenSans-Regular", size: 28))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // "Today" button aligned to the trailing edge, centered vertically
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.snappy) {
                            let today = Date()
                            currentDate = today

                            // Check if today's week exists in the weekSlider
                            if let index = weekSlider.firstIndex(where: { week in
                                week.contains { isSameDate($0.date, today) }
                            }) {
                                currentWeekIndex = index
                          }
                        }
                    }, label: {
                        Text("Today")
                            .font(.custom("OpenSans-Regular", size: 16))
                            .fontWeight(.bold)
                            .padding(8)
                            .background(Color("SlateBlue"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    })
                }
            }
            
            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(Color("SlateBlue"))
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            if day.date.isToday {
                                Circle()
                                    .fill(Color("SlateBlue"))
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            print("Generate")
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        ///Safe Check
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = (weekSlider.count - 2)
                
            }
        }
        print(weekSlider.count)
    }
    
}

#Preview {
    LogView()
}



