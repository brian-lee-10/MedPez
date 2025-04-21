import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var name = "NAME"
    @State private var showCalendar = false
    @State private var showNewTask = false
    @State private var showBluetooth = false
    @State private var remainingPillsToday: Int = 0

    
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            // Greeting and Date Header
            HStack {
                Text("\(getGreeting()), \(name)")
                    .font(.custom("OpenSans-Bold", size: 24))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    NextDoseCard()
                    MyCalendarCard(showCalendar: $showCalendar)
                    PillsRemainingTodayCard(pillsRemaining: 4)
                    PillsLeftInMedPezCard(pillsLeft: 14)
                    MyDeviceCard(showBluetooth: $showBluetooth)
                    AddMedicationCard(showNewTask: $showNewTask)
                }

                .padding()
            }
            .navigationDestination(isPresented: $showCalendar) {
                LogView()
            }
            .navigationDestination(isPresented: $showBluetooth) {
                BluetoothView()
            }
            .sheet(isPresented: $showNewTask) {
                NewTaskView()
                    .presentationDetents([.height(410)])
                    .interactiveDismissDisabled()
                    .presentationCornerRadius(30)
            }
            Spacer()
        }
        .onAppear {
            loadProfile()
        }
        .onAppear {
            fetchRemainingPillsForToday()
        }

        .navigationBarHidden(true)
    }

    // Function to get greeting based on time of day
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<18: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    // Fetch user profile from Firestore
    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    let fullName = data?["name"] as? String ?? "Unknown"
                    self.name = fullName.components(separatedBy: " ").first ?? fullName
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func fetchRemainingPillsForToday() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        db.collection("users")
            .document(user.uid)
            .collection("medications")
            .whereField("taskDate", isGreaterThanOrEqualTo: Timestamp(date: today))
            .whereField("taskDate", isLessThan: Timestamp(date: tomorrow))
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    return
                }

                let documents = snapshot?.documents ?? []
                let uncompletedTasks = documents.filter { doc in
                    let isCompleted = doc.data()["taskComplete"] as? Bool ?? false
                    return !isCompleted
                }

                self.remainingPillsToday = uncompletedTasks.count
            }
    }
}

struct NextDoseCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Next Dose")
                .font(.caption)
                .foregroundColor(.white)
            Text("2:00 PM")
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.green)
        .cornerRadius(16)
    }
}

struct MyCalendarCard: View {
    @Binding var showCalendar: Bool
    
    var body: some View {
        Button(action: { showCalendar = true }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("My Calendar")
                    .font(.headline)
                    .foregroundColor(.white)
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.purple)
            .cornerRadius(16)
        }
    }
}

struct MyDeviceCard: View {
    @Binding var showBluetooth: Bool
    
    var body: some View {
        Button(action: { showBluetooth = true }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("My Device")
                    .font(.headline)
                    .foregroundColor(.white)
                Image(systemName: "bolt.horizontal.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.blue)
            .cornerRadius(16)
        }
    }
}

struct AddMedicationCard: View {
    @Binding var showNewTask: Bool
    
    var body: some View {
        Button(action: { showNewTask = true }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("New Medicine")
                    .font(.headline)
                    .foregroundColor(.white)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.mint)
            .cornerRadius(16)
        }
    }
}

struct PillsRemainingTodayCard: View {
    var pillsRemaining: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pills Remaining")
                .font(.caption)
                .foregroundColor(.white)
            Text("\(pillsRemaining) today")
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.indigo)
        .cornerRadius(16)
    }
}

struct PillsLeftInMedPezCard: View {
    var pillsLeft: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("In MedPez")
                .font(.caption)
                .foregroundColor(.white)
            Text("\(pillsLeft) pills")
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.gray)
        .cornerRadius(16)
    }
}


#Preview {
    ContentView()
}
