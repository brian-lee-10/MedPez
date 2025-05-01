import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoggedIn {
                    ContentView()
                } else {
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
                    
                    Spacer()
                    
                    Text("Welcome")
                        .font(.custom("OpenSans-Bold", size: 30))
                    Text("Login to access your account below.")
                        .font(.custom("OpenSans-Regular", size: 17))
                        .padding(.vertical, 3)
                    
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
                    .padding(.horizontal, 30)
                    
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
                    .padding(.horizontal, 30)
                    
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
                            .background(Color("SlateBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 30)
                    Spacer()
                    
                    // Sign Up Section
                    NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                        Text("Create an account")
                            .font(.custom("OpenSans-Bold", size: 19))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
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
