//
//  BluetoothView.swift
//  MedPez
//
//  Created by Brian Lee on 1/27/25.
//

import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State private var showDisconnectAlert = false
    @State private var showPairingView = false
    @State private var areNotificationsAuthorized: Bool = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @State private var showTurnOffAlert = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack {
            Color.BG
                .ignoresSafeArea()

            VStack (spacing: 8){
                /// Device Info
                HStack {
                    Text("My Device")
                        .font(.custom("OpenSans-Bold", size: 34))
                        .padding(.horizontal)
                    Spacer()
                    if bluetoothManager.connectedPeripheralUUID != nil {
                        HStack(spacing: 6) {
                            Text("\(bluetoothManager.batteryLevel)%")
                                .font(.custom("OpenSans-Bold", size: 20))
                                .foregroundColor(bluetoothManager.batteryLevel < 20 ? .red : .black)

                            Image(systemName: batteryIconName(bluetoothManager.batteryLevel))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 16)
                                .foregroundColor(bluetoothManager.batteryLevel < 20 ? .red : .black)
                        }
                        .padding(.top, 2)
                        .padding(.horizontal)
                    }
                }
                
                // Device Heading
                VStack {
                    HStack {
                        Text("MedPez 1.0")
                            .font(.custom("OpenSans-Bold", size: 24))
                        
                        Spacer()
                        
                        if bluetoothManager.connectedPeripheralUUID != nil {
                            Text("Connected")
                                .font(.custom("OpenSans-Regular", size: 17))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .cornerRadius(10)
                        } else {
                            Text("Disconnected")
                                .font(.custom("OpenSans-Regular", size: 17))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                }
                
                /// Device Image Placeholder
                Image("device_image")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                    .padding(.horizontal)
                    .padding(.vertical, 24)
                
                /// Info Grid
                HStack(spacing: 12) {
                    // Pills Left
                    VStack(spacing: 10) {
                        Text("In MedPez")
                            .font(.custom("OpenSans-Regular", size: 14))
                        Text("\(bluetoothManager.pillCount)")
                            .font(.custom("OpenSans-Bold", size: 26))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.BG))
                    .cornerRadius(12)

                    
                    // Notification Toggle
                    VStack(spacing: 10) {
                        Text("Notifications")
                            .font(.custom("OpenSans-Regular", size: 14))

                        Toggle("", isOn: Binding(
                            get: { notificationsEnabled },
                            set: { newValue in
                                if newValue {
                                    notificationsEnabled = true
                                    showSuccessMessage = true
                                } else {
                                    showTurnOffAlert = true
                                }
                            }
                        ))
                        .labelsHidden()
                        .disabled(!areNotificationsAuthorized)
                        .alert("Turn Off Notifications?", isPresented: $showTurnOffAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Turn Off", role: .destructive) {
                                notificationsEnabled = false
                            }
                        } message: {
                            Text("You may miss medication reminders if notifications are off.")
                        }
                        .alert("Notifications Enabled", isPresented: $showSuccessMessage) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("You’ll receive reminders at your scheduled medication times.")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.BG))
                    .cornerRadius(12)

                }
                .padding(.horizontal)
                
                /// Disconnect Button
                // If connected -> show Disconnect button
                if bluetoothManager.connectedPeripheralUUID != nil {
                    Button(action: {
                        showDisconnectAlert = true
                    }) {
                        HStack {
                            Image(systemName: "bluetooth")
                            Text("Disconnect")
                                .font(.custom("OpenSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(14)
                    }
                    .padding()
                    .alert(isPresented: $showDisconnectAlert) {
                        Alert(
                            title: Text("Disconnect Device"),
                            message: Text("Are you sure you want to disconnect from this device?"),
                            primaryButton: .destructive(Text("Disconnect")) {
                                bluetoothManager.disconnect()
                                showPairingView = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                } else {
                    // If not connected -> show Connect button
                    Button(action: {
                        showPairingView = true
                    }) {
                        HStack {
                            // Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("Connect")
                                .font(.custom("OpenSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SlateBlue"))
                        .cornerRadius(14)
                    }
                    .padding()
                    .sheet(isPresented: $showPairingView) {
                        PairingView(bluetoothManager: bluetoothManager)
                            .presentationDetents([.height(600)])
                            .interactiveDismissDisabled()
                            .presentationCornerRadius(30)
                    }
                }
            }
            .padding(.top, -40)
        }
        .onAppear {
            bluetoothManager.initializeCentralManager()
            
            if bluetoothManager.isSwitchedOn {
                bluetoothManager.startScanning()
            }
            
            // Check if Notifications are allowed
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    areNotificationsAuthorized = (settings.authorizationStatus == .authorized)
                    if !areNotificationsAuthorized {
                        notificationsEnabled = false
                    }
                }
            }
        }
    }
    func batteryIconName(_ percent: Int) -> String {
        switch percent {
        case 80...100: return "battery.100"
        case 60..<80: return "battery.75"
        case 40..<60: return "battery.50"
        case 20..<40: return "battery.25"
        case 0..<20: return "battery.0"
        default: return "battery.0" // default or unknown
        }
    }
}

#Preview {
    BluetoothView()
        .environmentObject(BluetoothManager())
}
