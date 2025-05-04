//
//  PairingView.swift
//  MedPez
//
//  Created by Brian Lee on 1/27/25.
//
//
//
import SwiftUI
import CoreBluetooth

struct PairingView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.dismiss) private var dismiss
    @State private var isConnecting = false

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding()
                Spacer()
            }

            Image("device_image")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.top)

            Text("Pair Your MedPez Device")
                .font(.custom("OpenSans-Bold", size: 24))
                .multilineTextAlignment(.center)

            if bluetoothManager.connectedPeripheralUUID != nil {
                Label("Device Connected", systemImage: "checkmark.circle.fill")
                    .font(.custom("OpenSans-Regular", size: 18))
                    .foregroundColor(.green)
            } else if isConnecting {
                ProgressView("Connecting...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let device = bluetoothManager.peripherals.first(where: { $0.name == "MedPez Pill Dispenser" }) {
                Button(action: {
                    isConnecting = true
                    bluetoothManager.connect(to: device)
                }) {
                    Text("Connect to MedPez")
                        .font(.custom("OpenSans-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SlateBlue"))
                        .cornerRadius(14)
                        .padding(.horizontal)
                }
            } else {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Searching for MedPez Pill Dispenser...")
                        .font(.custom("OpenSans-Regular", size: 16))
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .onAppear {
            if bluetoothManager.isSwitchedOn {
                bluetoothManager.startScanning()
            }
        }
        .onChange(of: bluetoothManager.connectedPeripheralUUID) {
            isConnecting = false
        }
    }
}
