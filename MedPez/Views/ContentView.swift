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
            
            Spacer()
        }
        .onAppear {
            loadProfile()
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
}

#Preview {
    ContentView()
}
