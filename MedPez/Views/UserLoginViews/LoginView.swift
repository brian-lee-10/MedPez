import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var isPasswordVisible = false

    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    Image(systemName: "pills")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                    Text("MedPez")
                        .font(.custom("OpenSans-Bold", size: 30))
                        .bold()
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Welcome")
                    .font(.custom("OpenSans-Bold", size: 30))
                    .foregroundColor(.black)
                    .dynamicTypeSize(.large)
                Text("Login to access your account below.")
                    .font(.custom("OpenSans-Regular", size: 17))
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.vertical, 3)
                    .dynamicTypeSize(.medium)
                
                // Email Input Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .font(.custom("OpenSans-Bold", size: 17))
                        .foregroundColor(.black)
                    
                    TextField("Enter your email...", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1) // Grey border
                        )
                        .foregroundColor(.black)
                        .font(.custom("OpenSans-Regular", size: 17))
                }
                
                // Password Input Field
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Password")
                            .font(.custom("OpenSans-Bold", size: 17))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.custom("OpenSans-Bold", size: 17))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter your password...", text: $password)
                                .font(.custom("OpenSans-Regular", size: 17))
                        } else {
                            SecureField("Enter your password...", text: $password)
                                .font(.custom("OpenSans-Regular", size: 17))
                        }
                        
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Grey border
                    )
                    .foregroundColor(.black)
                }
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Login Button
                Button(action: { loginUser() }) {
                    Text("Login")
                        .font(.custom("OpenSans-Bold", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Spacer ()
                
                // Sign Up Section
                NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                    Text("Create an account")
                        .font(.custom("OpenSans-Bold", size: 19))
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
    

    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    LoginView()
}
