import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            NavigationStack {
                VStack {
                    Spacer() // Push content down to center vertically

                    VStack(spacing: 16) {
                        Text("MedPez")
                            .font(.largeTitle)
                            .padding()

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        Button(action: {
                            loginUser()
                        }) {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 400) // Constrain the width of the VStack
                    .multilineTextAlignment(.center)

                    Spacer() // Push content up to center vertically
                    
                    VStack{
                        Text("New to MedPez?")
                        NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)){
                            Text("Create an Account")
                        }
                        
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .foregroundColor(.blue)
                                .padding(.top)
                        }
                    }
                    Spacer()
                }
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

//#Preview {
//    LoginView()
//}
