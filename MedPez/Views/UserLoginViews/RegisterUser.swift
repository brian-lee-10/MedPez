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
        VStack(spacing: 20) {
            Spacer()
            
            Text("Get Started")
                .font(.custom("OpenSans-Bold", size: 30))
            
            Text("Create your account below.")
                .font(.custom("OpenSans-Regular", size: 17))
                .padding(.vertical, 3)
            
            // Name Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Full Name")
                    .font(.custom("OpenSans-Bold", size: 17))
                TextField("Enter your full name...", text: $name)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .padding()
                    .cornerRadius(8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Grey border
                    )
                    
            }
            
            // Email Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Email Address")
                    .font(.custom("OpenSans-Bold", size: 17))
                TextField("Enter your email...", text: $email)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .cornerRadius(8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Grey border
                    )
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Password")
                    .font(.custom("OpenSans-Bold", size: 17))
                SecureField("Enter your password...", text: $password)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .padding()
                    .cornerRadius(8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Grey border
                    )
            }
            
            // Register Button
            Button(action: { registerUser() }) {
                Text("Create Account")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.top, 10)
            Spacer()
        }
        .padding(.horizontal, 30)
        .background(.BG)
        .preferredColorScheme(.light)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue) // Custom back button color
                Text("Login")
                    .foregroundColor(.blue) // Custom back button color
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

#Preview {
    RegisterView(isLoggedIn: .constant(false))
}
