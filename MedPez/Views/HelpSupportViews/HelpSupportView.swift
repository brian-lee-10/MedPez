//
//  HelpSupportView.swift
//  MedPez
//
//  Created by Brian Lee on 4/15/25.
//

import SwiftUI
import MessageUI

struct HelpSupportView: View {
    @State private var isShowingMailView = false
    @State private var showMailError = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Help & Support")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)
                .padding(.horizontal)

            List {
                Section(header: Text("Support")) {
                    Button(action: {
//                        if MFMailComposeViewController.canSendMail() {
//                            isShowingMailView = true
//                        } else {
//                            showMailError = true
//                        }
                    }) {
                        Label("Contact Email Support", systemImage: "envelope")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }

                Section(header: Text("App Guide")) {
                    NavigationLink(destination: HowToUseAppView()) {
                        Label("How to Use App", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
                
                Section(header: Text("MedPez Guide")) {
                    NavigationLink(destination: HowToUseMedPezView()) {
                        Label("How to Use App", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
                
                Section(header: Text("Connection Guide")) {
                    NavigationLink(destination: HowToConnectView()) {
                        Label("How to Use App", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }

                Section(header: Text("Emergency")) {
                    HStack {
                        Label("Emergency Call (Coming Soon)", systemImage: "phone.fill")
                            .foregroundColor(.gray)
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())

            Spacer()
        }
        .sheet(isPresented: $isShowingMailView) {
//            MailView(recipientEmail: "support@medpez.com")
        }
        .alert("Email Not Available", isPresented: $showMailError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please configure a mail account in order to send emails.")
        }
    }
}


#Preview {
    HelpSupportView()
}
