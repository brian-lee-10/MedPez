import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @State private var name = ""
    @State private var birthdate = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

//            VStack(alignment: .leading) {
//                Text("Age")
//                    .font(.headline)
//
//                TextField("\(calculateAge(from: birthdate))", text: .constant(""))
//                    .onTapGesture {
//                        withAnimation {
//                            showDatePicker.toggle()
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .disabled(true) // Prevent manual input
//
//                if showDatePicker {
//                    DatePicker(
//                        "Select Birthdate",
//                        selection: $birthdate,
//                        displayedComponents: .date
//                    )
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .transition(.opacity) // Smooth appearance
//                }
//            }
//            .padding(.bottom)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action: registerUser) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

//    private func calculateAge(from birthdate: Date) -> Int {
//        let calendar = Calendar.current
//        let now = Date()
//        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
//        return ageComponents.year ?? 0
//    }

    private func registerUser() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }

            guard let user = authResult?.user else { return }

            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    alertMessage = "Error saving user data: \(error.localizedDescription)"
                } else {
                    alertMessage = "Registration successful!"
                    isLoggedIn = true
                }
                showAlert = true
            }
        }
    }

}
