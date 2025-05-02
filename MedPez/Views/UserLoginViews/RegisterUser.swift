import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @State private var birthdate = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FocusState private var isPasswordFocused: Bool
    @State private var goToOnboarding = false
    
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
            .background(Color("SlateBlue"))
            .edgesIgnoringSafeArea(.top)
            
            Text("Get Started")
                .font(.custom("OpenSans-Bold", size: 30))
                .padding(.horizontal, 30)
            
            Text("Create your account below.")
                .font(.custom("OpenSans-Regular", size: 17))
                .padding(.vertical, 2)
                .padding(.horizontal, 30)
            
            /// Email Field
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
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 30)
            
            /// Password Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Password")
                    .font(.custom("OpenSans-Bold", size: 17))
                /// Password Requirements List
                if isPasswordFocused {
                    HStack {
                        VStack{
                            Label("At least 1 uppercase letter", systemImage: hasUppercase ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(hasUppercase ? .green : .red)
                            
                            Label("At least 1 lowercase letter", systemImage: hasLowercase ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(hasLowercase ? .green : .red)
                        }
                        .font(.custom("OpenSans-Regular", size: 12))
                        
                        VStack {
                            Label("At least 1 number", systemImage: hasNumber ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(hasNumber ? .green : .red)
                            
                            Label("Minimum 10 characters", systemImage: isLongEnough ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(isLongEnough ? .green : .red)
                        }
                        .font(.custom("OpenSans-Regular", size: 12))
                    }
                }
                
                HStack {
                    if isPasswordVisible {
                        TextField("Enter your password...", text: $password)
                            .font(.custom("OpenSans-Regular", size: 17))
                            .focused($isPasswordFocused)
                    } else {
                        SecureField("Enter your password...", text: $password)
                            .font(.custom("OpenSans-Regular", size: 17))
                            .focused($isPasswordFocused)
                    }
                    
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                            .padding(6)
                    }
                }
                .padding()
                .cornerRadius(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                
                
            }
            .padding(.horizontal, 30)
            
            // Register Button
            Button(action: { registerUser() }) {
                Text("Create Account")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color("SlateBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            Spacer()
        }
            
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
                    isLoggedIn = true
                }
            })
        }
    }
    
    /// Register User Function
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
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
                "email": email
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
    
    /// Requiremens Functions
    var hasUppercase: Bool {
        password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    var hasLowercase: Bool {
        password.range(of: "[a-z]", options: .regularExpression) != nil
    }

    var hasNumber: Bool {
        password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    var isLongEnough: Bool {
        password.count >= 10
    }

}

#Preview {
    RegisterView(isLoggedIn: .constant(false))
}
