//
//  PairingView.swift
//  MedPez
//
//  Created by Brian Lee on 1/27/25.
//
//
//
import Foundation
import SwiftUI
import CoreBluetooth

struct PairingView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select a device to pair")
                    .font(.headline)
                    .padding()

                List(bluetoothManager.peripherals.filter { $0.name != "Unknown" }) { peripheral in
                    HStack {
                        Text(peripheral.name)
                        Spacer()
                        Button("Connect") {
                            bluetoothManager.connect(to: peripheral)
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                }

                Spacer()
            }
            .navigationTitle("Pair Device")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
