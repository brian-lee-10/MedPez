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
        VStack(spacing: 10){
            Text ("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            
            List(bluetoothManager.peripherals) { peripheral in
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
            
            Spacer()
            
            Text("Status")
                .font(.headline)
            
            if bluetoothManager.isSwitchedOn {
                Text("Bluetooth is ON")
                    .foregroundColor(.green)
            } else {
                Text("Bluetooth is OFF")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            VStack(spacing: 25) {
                Button(action: {
                    bluetoothManager.startScanning()
                }) {
                    Text ("Start Scanning")
                }.buttonStyle(BorderedProminentButtonStyle())
                
                Button(action: {
                    bluetoothManager.stopScanning()
                }) {
                    Text ("Stop Scanning")
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

