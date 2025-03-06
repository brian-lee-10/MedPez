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
            ZStack {
                // High-contrast Gradient Background
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 15) {
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

                    Text("Welcome back")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .dynamicTypeSize(.large)

                    Text("Login to access your account below.")
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.vertical, 3)
                        .dynamicTypeSize(.medium)

                    // Email Input Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Email Address")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    // Password Input Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        HStack {
                            if isPasswordVisible {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }

                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    // Forgot Password Link
                    HStack {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                                .underline()
                        }

                        Spacer()

                        // Login Button
                        Button(action: { loginUser() }) {
                            Text("Login")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(30)
                        }
                    }
                    .padding()

                    // Sign Up Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 50)

                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.white)
                            NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                                Text("Create →")
                                    .foregroundColor(.yellow)
                                    .bold()
                                    .underline()
                            }
                        }
                        .padding()
                    }

                    Spacer()
                }
                .padding(.horizontal, 30)
            }
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
