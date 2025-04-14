import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var name = "NAME"
    
    var body: some View {
        VStack {
            // Greeting and Date Header
            HStack {
                Text("\(getGreeting()), \(name)")
                    .font(.custom("OpenSans-Bold", size: 24))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            // Current Day and Date
//            Text(getCurrentDayAndDate())
//                .font(.custom("OpenSans-Regular", size: 16))
//                .foregroundColor(.gray)
//                .padding([.leading, .trailing])
            
            // Widgets
            VStack(spacing: 15) {
                // Pills Widget
                WidgetView(title: "Pills Left", value: "5 Pills Remaining", iconName: "pill.fill", color: .blue)
                
                // Next Dose Widget
                WidgetView(title: "Next Dose", value: "12:30 PM", iconName: "clock.fill", color: .green)
                
                // New Medication Button
                Button(action: {
                    // Navigate to New Medication View
                    print("Navigate to New Medication View")
                }) {
                    Text("Add New Medication")
                        .font(.custom("OpenSans-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding([.leading, .trailing])
                
                // Navigate to Device Tab
                NavigationLink(destination: BluetoothView()) {
                    Text("Go to Device Tab")
                        .font(.custom("OpenSans-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding([.leading, .trailing])
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .onAppear {
            loadProfile()
        }
        .navigationBarHidden(true)
    }
    
    // Widget View: Custom view to reuse for widgets like Pills, Next Dose, etc.
    private func WidgetView(title: String, value: String, iconName: String, color: Color) -> some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(color, in: Circle())
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.custom("OpenSans-Bold", size: 22))
                        .foregroundColor(.black)
                    Text(value)
                        .font(.custom("OpenSans-Regular", size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
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
}

#Preview {
    ContentView()
}
