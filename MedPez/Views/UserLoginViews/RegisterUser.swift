import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @State private var name = ""
    @State private var birthdate = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                Spacer()
                // Logo & Title
                HStack {
                    Image(systemName: "circle.grid.3x3.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    Text("MedPez")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                
                Text("Get Started")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Create your account below.")
                    .foregroundColor(.white)
                    .padding(.vertical, 3)
                
                // Name Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Full Name")
                        .foregroundColor(.white)
                    TextField("Enter your full name...", text: $name)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                // Birthdate Picker
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Birthdate")
//                        .foregroundColor(.white)
//                    DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
//                        .datePickerStyle(CompactDatePickerStyle())
//                        .padding()
//                        .background(Color.white.opacity(0.2))
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .foregroundColor(.white)
                    TextField("Enter your email...", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .foregroundColor(.white)
                    SecureField("Enter your password...", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                // Register Button
                HStack {
                    Spacer()
                    Button(action: { registerUser() }) {
                        Text("Create Account")
                            .padding(.horizontal, 37)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                }
                .padding(.top, 10)
                Spacer()
            }
            .padding(.horizontal, 30)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white) // Custom back button color
                Text("Login")
                    .foregroundColor(.white) // Custom back button color
            }
        })
    }
    
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
                "email": email,
                "birthdate": birthdateFormatter.string(from: birthdate)
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
    
    private var birthdateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    RegisterView(isLoggedIn: .constant(false))
}
