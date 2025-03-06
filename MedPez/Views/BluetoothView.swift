//
//  BluetoothView.swift
//  MedPez
//
//  Created by Brian Lee on 1/27/25.
//


import Foundation
import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View{
        VStack(spacing: 8){
            Text("Bluetooth")
                .font(.custom("OpenSans-Bold", size: 34))
                .padding()
            HStack {
                Text("Status")
                    .font(.custom("OpenSans-Bold", size: 17))
            
                if bluetoothManager.isSwitchedOn {
                    Text("Bluetooth is ON")
                        .font(.custom("OpenSans-Regular", size: 17))
                        .foregroundColor(.green)
                } else {
                    Text("Bluetooth is OFF")
                        .font(.custom("OpenSans-Regular", size: 17))
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Text("Pill Count")
                    .font(.custom("OpenSans-Bold", size: 17))
                Text(bluetoothManager.receivedData) // Display received BLE data
                    .font(.custom("OpenSans-Regular", size: 17))
                    .foregroundColor(.blue)
                    .padding()
            }
            
            List(bluetoothManager.peripherals.filter { $0.name != "Unknown" }) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer ()
                    Text(String(peripheral.rssi))
                    Button (action: {
                        bluetoothManager.connect (to: peripheral)
                    }) {
                        if bluetoothManager.connectedPeripheralUUID == peripheral.id {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Text("Connect")
                        }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2)

            if let connectedPeripheralUUID = bluetoothManager.connectedPeripheralUUID, let connectedPeripheral = bluetoothManager.peripherals.first(where: { $0.id == connectedPeripheralUUID }) {
                Text("Connected to \(connectedPeripheral.name)")
                    .font(.custom("OpenSans-Regular", size: 17))
                    .foregroundColor(.green)
                    .padding()
                Button(action: {
                    bluetoothManager.disconnect()
                }) {
                    Text("Disconnect")
                        .font(.custom("OpenSans-Regular", size: 17))
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderedButtonStyle())
            } else {
                Text("Not connected to any device")
                    .font(.custom("OpenSans-Regular", size: 17))
                    .foregroundColor(.red)
                    .padding()
            }
            
            HStack(spacing: 25) {
                Button(action: {
                    bluetoothManager.startScanning()
                }) {
                    Text ("Start Scanning")
                        .font(.custom("OpenSans-Regular", size: 17))
                }.buttonStyle(BorderedProminentButtonStyle())
                
                Button(action: {
                    bluetoothManager.stopScanning()
                }) {
                    Text ("Stop Scanning")
                        .font(.custom("OpenSans-Regular", size: 17))
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .padding()
            
            Spacer()
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
