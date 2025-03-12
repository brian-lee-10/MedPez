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
    
    @Environment(\.presentationMode) var presentationMode  // <-- Add this
    
    var body: some View {
        VStack(spacing: 20) {
            /// Top Banner
            HStack {
                Image(systemName: "pill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .offset(y: 20)
                
                Text("MedPez")
                    .font(.custom("OpenSans-Bold", size: 30))
                    .foregroundColor(.white)
                    .offset(y: 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(Color.purple)
            .edgesIgnoringSafeArea(.top)
            
            Text("Get Started")
                .font(.custom("OpenSans-Bold", size: 30))
                .padding(.horizontal, 30)
            
            Text("Create your account below.")
                .font(.custom("OpenSans-Regular", size: 17))
                .padding(.vertical, 3)
                .padding(.horizontal, 30)
            
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
            .padding(.horizontal, 30)
            
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
            .padding(.horizontal, 30)
            
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
            .padding(.horizontal, 30)
            
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
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(.BG)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Back")
                    .foregroundColor(.white)
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage == "Registration successful!" {
                    presentationMode.wrappedValue.dismiss()  // <-- Go back to LoginView
                }
            })
        }
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
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    RegisterView(isLoggedIn: .constant(false))
}
