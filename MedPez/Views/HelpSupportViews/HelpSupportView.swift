//
//  HelpSupportView.swift
//  MedPez
//
//  Created by Brian Lee on 4/15/25.
//

import SwiftUI

struct HelpSupportView: View {
    @State private var isShowingMailView = false
    @State private var showMailError = false
    @State private var showCallAlert = false


    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Help & Support")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)
                .padding(.horizontal)
            
            List {
                /// Email Support
                Section(header: Text("Contact Support")) {
                    Button(action: {
                        if let url = URL(string: "mailto:medpez.study@gmail.com?subject=MedPez%20Support&body=Hi%20MedPez%20Team,") {
                            UIApplication.shared.open(url)
                        } else {
                            showMailError = true
                        }
                    }) {
                        Label("Need Help?", systemImage: "envelope")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
                
                /// Emergency Services
                Section(header: Text("Emergency")) {
                    HStack {
                        Button(action: {
                            showCallAlert = true
                        }) {
                            Label("Emergency Help (911)", systemImage: "phone.fill")
                                .font(.custom("OpenSans-Regular", size: 18))
                                .foregroundColor(.red)
                        }
                        .alert("Emergency Call", isPresented: $showCallAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Call", role: .destructive) {
                                if let url = URL(string: "tel://911"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        } message: {
                            Text("This will call emergency services. Are you sure?")
                        }
                        
                    }
                }
                
                /// Guides
                Section(header: Text("Guides")) {
                    NavigationLink(destination: HowToUseAppView()) {
                        Label("Getting Started", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                    
                    NavigationLink(destination: HowToUseMedPezView()) {
                        Label("Using MedPez", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                    
                    NavigationLink(destination: HowToConnectView()) {
                        Label("Device Setup Guide", systemImage: "book")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            
            Spacer()
        }
    }
}


#Preview {
    HelpSupportView()
}
