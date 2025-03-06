import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Change Password")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("Enter the email associated with your account and we will send you link to reset your password.")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                
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
                

                Button(action: resetPassword) {
                    Text("Send Reset Email")                    
                        .padding(.horizontal, 37)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.teal) // Custom back button color
                Text("Back")
                    .foregroundColor(.teal) // Custom back button color
            }
        })
    }

    private func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Password reset email sent! Check your inbox."
            }
            showAlert = true
        }
    }
}

#Preview {
    ForgotPasswordView()
}
