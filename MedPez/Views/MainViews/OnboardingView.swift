//
//  OnboardingView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPage(imageName: "pill", title: "Welcome to MedPez", description: "Track your medication and stay on schedule.")
                        .tag(0)
                    OnboardingPage(imageName: "calendar", title: "Smart Reminders", description: "Get alerts for your next dose automatically.")
                        .tag(1)
                    OnboardingPage(imageName: "iphone", title: "MedPez Integration", description: "Connect with your MedPez pill dispenser.")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                Button(action: {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Get Started")
                        .font(.custom("OpenSans-Bold", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SlateBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }

            /// Skip Button
            Button("Skip") {
                hasSeenOnboarding = true
            }
            .padding()
            .font(.custom("OpenSans-Regular", size: 16))
            .foregroundColor(.blue)
        }
    }
}


struct OnboardingPage: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(Color("SlateBlue"))
            
            Text(title)
                .font(.custom("OpenSans-Bold", size: 28))
            
            Text(description)
                .font(.custom("OpenSans-Regular", size: 18))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}
#Preview {
    OnboardingPage(imageName: "iphone", title: "MedPez Integration", description: "Connect with your MedPez pill dispenser.")
}
