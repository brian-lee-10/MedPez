import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var name = "NAME"
    @State private var showCalendar = false
    @State private var showNewTask = false
    @State private var showProfile = false
    @State private var showBluetooth = false
    @State private var remainingPillsToday: Int = 0

    
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            // Greeting and Date Header
            VStack(spacing: 2) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(getGreeting())")
                            .font(.custom("OpenSans-Bold", size: 28))
                            .foregroundColor(.black)
                        
                        if name != "User" && name != "Unknown" && !name.isEmpty {
                            Text(name)
                                .font(.custom("OpenSans-Bold", size: 30))
                                .foregroundColor(.black)
                        } else {
                            Text("Ready to stay on track?")
                                .font(.custom("OpenSans-Regular", size: 22))
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()

                    Button(action: {
                        showProfile = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, height: 42)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            /// Dashboard widgets
            VStack(spacing: 16) {
                // Full-width Next Dose
                NextDoseCard()
                    .frame(maxWidth: .infinity, minHeight: 100)

                HStack {
                    VStack (spacing: 16) {
                        MyCalendarCard(showCalendar: $showCalendar)
                        PillsLeftInMedPezCard(pillsLeft: 14)
                    }
                    MyDeviceCard(showBluetooth: $showBluetooth)
                }

                HStack {
                    PillsRemainingTodayCard(pillsRemaining: remainingPillsToday)
                        .frame(maxWidth: .infinity, minHeight: 100)
                    
                    AddMedicationCard(showNewTask: $showNewTask)
                }
            }
            .padding()

            .navigationDestination(isPresented: $showCalendar) {
                LogView()
            }
            .navigationDestination(isPresented: $showBluetooth) {
                BluetoothView()
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showNewTask) {
                NewTaskView()
                    .presentationDetents([.height(430)])
                    .interactiveDismissDisabled()
                    .presentationCornerRadius(30)
            }
            Spacer()
        }
        .onAppear {
            loadProfile()
            startListeningToRemainingPills()
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
                    let fullName = data?["name"] as? String ?? "User"
                    self.name = fullName.components(separatedBy: " ").first ?? fullName
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func startListeningToRemainingPills() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        db.collection("users")
            .document(user.uid)
            .collection("medications")
            .whereField("taskDate", isGreaterThanOrEqualTo: Timestamp(date: today))
            .whereField("taskDate", isLessThan: Timestamp(date: tomorrow))
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to tasks: \(error.localizedDescription)")
                    return
                }

                let documents = snapshot?.documents ?? []
                let uncompletedTasks = documents.filter { doc in
                    let isCompleted = doc.data()["taskComplete"] as? Bool ?? false
                    return !isCompleted
                }

                DispatchQueue.main.async {
                    self.remainingPillsToday = uncompletedTasks.count
                }
            }
    }

}

struct NextDoseCard: View {
    @State private var nextDoseTime: Date? = nil
    @State private var noUpcomingDose = false
    @State private var nextDoseName: String = ""
    @State private var nextDoseDosage: String = ""

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack (alignment: .leading) {
                    Text("Next Dose")
                        .font(.custom("OpenSans-Bold", size: 26))
                        .foregroundColor(.white)
                    
                    Text(currentDateFormatted)
                        .font(.custom("OpenSans-Regular", size: 15))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack {
                    if noUpcomingDose {
                        Text("No Medication")
                            .font(.custom("OpenSans-Regular", size: 20))
                            .foregroundColor(.white.opacity(0.9))
                    } else{
                        if !nextDoseName.isEmpty {
                            Text(nextDoseName)
                                .font(.custom("OpenSans-Bold", size: 20))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        if !nextDoseDosage.isEmpty {
                            Text("\(nextDoseDosage) mg")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text(formatNextDoseTime())
                    .font(.custom("OpenSans-Bold", size: 60))
                    .foregroundColor(Color("SlateBlue"))
                
                Spacer()
                
                if isOverdue {
                    Label("OVERDUE", systemImage: "exclamationmark.triangle.fill")
                        .font(.custom("OpenSans-Bold", size: 20))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: 220, maxHeight:220)
        .background(Color("Night"))
        .cornerRadius(16)
        .onAppear {
            fetchNextDoseTime()
        }

    }
    
    private func formatNextDoseTime() -> String {
        guard let nextDoseTime else { return "--:-- AM" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: nextDoseTime)
    }
    
    private var isOverdue: Bool {
        if let time = nextDoseTime {
            return time < Date()
        }
        return false
    }
    
    private var currentDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    private func fetchNextDoseTime() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        
        db.collection("users")
            .document(user.uid)
            .collection("medications")
            .whereField("taskDate", isGreaterThanOrEqualTo: Timestamp(date: startOfToday))
            .order(by: "taskDate", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching doses: \(error.localizedDescription)")
                    return
                }

                let documents = snapshot?.documents ?? []

                // Filter: Only unfinished tasks
                if let nextTask = documents.first(where: { !($0.data()["taskComplete"] as? Bool ?? false) }) {
                    DispatchQueue.main.async {
                        self.nextDoseTime = (nextTask.data()["taskDate"] as? Timestamp)?.dateValue()
                        self.nextDoseName = nextTask.data()["taskTitle"] as? String ?? ""
                        self.nextDoseDosage = nextTask.data()["dosage"] as? String ?? ""
                        self.noUpcomingDose = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.noUpcomingDose = true
                        self.nextDoseTime = nil
                    }
                }
            }
    }
}

struct MyCalendarCard: View {
    @Binding var showCalendar: Bool
    
    var body: some View {
        Button(action: { showCalendar = true }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("My Calendar")
                    .font(.custom("OpenSans-Regular", size: 22))
                    .foregroundColor(.white)
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color("SlateBlue"))
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
                    .font(.custom("OpenSans-Regular", size: 24))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "bolt.horizontal.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(minHeight: 256, maxHeight: 256)
            .background(Color("Smoke"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}

struct AddMedicationCard: View {
    @Binding var showNewTask: Bool
    
    var body: some View {
        Button(action: { showNewTask = true }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("New Medicine")
                    .font(.custom("OpenSans-Regular", size: 20))
                    .foregroundColor(.white)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("Smoke"))
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color("Jade"))
            .cornerRadius(16)
        }
    }
}

struct PillsRemainingTodayCard: View {
    var pillsRemaining: Int

    var body: some View {
        VStack {
            Text("Today's Progress")
                .font(.custom("OpenSans-Regular", size: 18))
                .foregroundColor(.black)
            Text("\(pillsRemaining)")
                .font(.custom("OpenSans-Bold", size: 32))
                .bold()
                .foregroundColor(.black)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color("Smoke"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

/// Pills sent from Device
struct PillsLeftInMedPezCard: View {
    var pillsLeft: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("In MedPez")
                .font(.custom("OpenSans-Regular", size: 18))
                .foregroundColor(.white)
            Text("\(pillsLeft) pills")
                .font(.custom("OpenSans-Bold", size: 28))
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color("Jade"))
        .cornerRadius(16)
    }
}


#Preview {
    ContentView()
}
