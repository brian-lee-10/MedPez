////
////  BluetoothView.swift
////  MedPez
////
////  Created by Brian Lee on 1/27/25.
////
//
//
//import Foundation
//import SwiftUI
//import CoreBluetooth
//
//struct PairingView: View {
//    @StateObject var bluetoothManager = BluetoothManager()
//    
//    var body: some View{
//        VStack(spacing: 8){
//            /// Header
//            HStack {
//                Text("Setup")
//                    .font(.custom("OpenSans-Bold", size: 34))
//                    .padding()
//                Spacer()
//            }
//            /// Device Header Details
//            VStack {
//                HStack {
//                    Text("Pairing")
//                        .font(.custom("OpenSans-Bold", size: 24))
//                    
//                    Spacer()
//                    
//                    /// Device Connectivity Status
//                    if let connectedPeripheralUUID = bluetoothManager.connectedPeripheralUUID, let connectedPeripheral = bluetoothManager.peripherals.first(where: { $0.id == connectedPeripheralUUID }) {
////                        Text("Connected to \(connectedPeripheral.name)")
////                            .font(.custom("OpenSans-Regular", size: 17))
////                            .foregroundColor(.green)
//                        Text("Connected")
//                            .font(.custom("OpenSans-Regular", size: 17))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 2) // Padding inside the background
//                            .background(Color.green)
//                            .cornerRadius(8)
//                        Button(action: {
//                            bluetoothManager.disconnect()
//                        }) {
//                            Text("Disconnect")
//                                .font(.custom("OpenSans-Regular", size: 17))
//                                .foregroundColor(.red)
//                        }
//                        .buttonStyle(BorderedButtonStyle())
//                    } else {
//                        Text("Disconnected")
//                            .font(.custom("OpenSans-Regular", size: 17))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 2) // Padding inside the background
//                            .background(Color.red)
//                            .cornerRadius(8)
//                    }
//                }
//                HStack{
//                    Text("Smart Pill Dispenser")
//                        .font(.custom("OpenSans-Regular", size: 18))
//                    Spacer()
//                }
//            }
//            .padding(.horizontal, 16)
//            
//            /// Checks if Bluetooth is on/off
////            HStack {
////                Text("Status")
////                    .font(.custom("OpenSans-Bold", size: 17))
////
////                if bluetoothManager.isSwitchedOn {
////                    Text("Bluetooth is ON")
////                        .font(.custom("OpenSans-Regular", size: 17))
////                        .foregroundColor(.green)
////                } else {
////                    Text("Bluetooth is OFF")
////                        .font(.custom("OpenSans-Regular", size: 17))
////                        .foregroundColor(.red)
////                }
////            }
//            
//            List(bluetoothManager.peripherals.filter { $0.name != "Unknown" }) { peripheral in
//                HStack {
//                    Text(peripheral.name)
//                    Spacer ()
//                    Text(String(peripheral.rssi))
//                    Button (action: {
//                        bluetoothManager.connect (to: peripheral)
//                    }) {
//                        if bluetoothManager.connectedPeripheralUUID == peripheral.id {
//                            Text("Connected")
//                                .foregroundColor(.green)
//                        } else {
//                            Text("Connect")
//                        }
//                    }
//                }
//            }
//            .frame(height: UIScreen.main.bounds.height / 4)
//            
//            HStack {
//                Text("Pill Count")
//                    .font(.custom("OpenSans-Bold", size: 17))
//                Text(bluetoothManager.receivedData) // Display received BLE data
//                    .font(.custom("OpenSans-Regular", size: 17))
//                    .foregroundColor(.blue)
//                    .padding()
//            }
//            
//            HStack(spacing: 25) {
//                Button(action: {
//                    bluetoothManager.startScanning()
//                }) {
//                    Text ("Start Scanning")
//                        .font(.custom("OpenSans-Regular", size: 17))
//                }.buttonStyle(BorderedProminentButtonStyle())
//                
//                Button(action: {
//                    bluetoothManager.stopScanning()
//                }) {
//                    Text ("Stop Scanning")
//                        .font(.custom("OpenSans-Regular", size: 17))
//                }
//                .buttonStyle(BorderedProminentButtonStyle())
//            }
//            .padding()
//            
//            Spacer()
//        }
//        .onAppear {
//            if bluetoothManager.isSwitchedOn {
//                bluetoothManager.startScanning()
//            }
//        }
//    }
//}
//
//#Preview {
//    PairingView()
//}
