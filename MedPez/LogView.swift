import SwiftUI

struct LogView: View {
//    @Environment(\.dismiss) var dismiss // Allows dismissing the current view

    var body: some View {
        VStack {
            Text("Log View")
                .font(.largeTitle)
                .padding()

            Text("Here you can see the logs of your activities.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss() // Go back to the previous screen
//                }) {
//                    Image("Back") // Replace with your asset's name
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                }
//            }
//        }
    }
}

#Preview {
    LogView()
}
