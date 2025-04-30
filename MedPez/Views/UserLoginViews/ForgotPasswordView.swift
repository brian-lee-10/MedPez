import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
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
            
            Text("Change Password")
                .font(.custom("OpenSans-Bold", size: 30))
            
            Text("Enter the email associated with your account and we will send you link to reset your password.")
                .font(.custom("OpenSans-Regular", size: 17))
                .padding(.horizontal, 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Email Address")
                    .font(.custom("OpenSans-Bold", size: 17))
                TextField("Enter your email...", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Grey border
                    )
            }
            .padding(.horizontal, 30)
            
            
            Button(action: resetPassword) {
                Text("Send Reset Email")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color("SlateBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.top)
            .padding(.horizontal, 30)
            
            Spacer()
        }
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
            Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")){
                if alertMessage == "Password reset email sent! Check your inbox." {
                    presentationMode.wrappedValue.dismiss()  // <-- Go back to LoginView
                }
            })
        }
        //.background(.BG)
        .preferredColorScheme(.light)
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
