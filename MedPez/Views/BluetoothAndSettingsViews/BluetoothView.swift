//
//  BluetoothView.swift
//  MedPez
//
//  Created by Brian Lee on 1/27/25.
//

import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var alarmOn = false
    @State private var showDisconnectAlert = false
    @State private var showPairingView = false
    
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
                    
                    HStack {
                        Text("Smart Pill Dispenser")
                            .font(.custom("OpenSans-Regular", size: 18))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
                
                /// Device Image Placeholder
                Image("device_image")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                    .padding()
                
                /// Info Grid
                HStack(spacing: 12) {
                    // Battery
                    VStack {
                        Text("Battery")
                            .font(.custom("OpenSans-Regular", size: 14))
                        Image(systemName: "battery.100")
                        Text("100%")
                            .font(.custom("OpenSans-Bold", size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Alarm Toggle
                    VStack {
                        Text("Alarm")
                            .font(.custom("OpenSans-Regular", size: 14))
                        Toggle("", isOn: $alarmOn)
                            .labelsHidden()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Override
                    VStack {
                        Text("Override")
                            .font(.custom("OpenSans-Regular", size: 14))
                        Button(action: {
                            // Handle override
                        }) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
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
                    }
                }
            }
        }
        .onAppear {
            if bluetoothManager.isSwitchedOn {
                bluetoothManager.startScanning()
            }
        }
    }
}


#Preview {
    BluetoothView()
}
