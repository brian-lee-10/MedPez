//
//  BluetoothManager.swift
//  MedPez
//
//  Created by Brian Lee on 1/28/25.
//

import Foundation
import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheralUUID: UUID?
    @Published var connectedPeripheral: CBPeripheral?
    @Published var receivedData: String = "Waiting for data..."
    @Published var pillCount: Int = 0
    let pillCountCharacteristicUUID = CBUUID(string: "beb5483e-0001-4688-b7f5-ea07361b26a8")

    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedOn = central.state == .poweredOn
        if isSwitchedOn {
            startScanning()
        } else {
            stopScanning()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
        if !peripherals.contains(where: { $0.id == newPeripheral.id }) {
            peripherals.append(newPeripheral)
        }
    }

    func connect(to peripheral: Peripheral) {
        guard let cbPeripheral = myCentral.retrievePeripherals(withIdentifiers: [peripheral.id]).first else { return }
        connectedPeripheralUUID = peripheral.id
        connectedPeripheral = cbPeripheral
        cbPeripheral.delegate = self
        myCentral.connect(cbPeripheral, options: nil)
    }

    func disconnect() {
        guard let connectedPeripheral = connectedPeripheral else { return }
        myCentral.cancelPeripheralConnection(connectedPeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        connectedPeripheralUUID = peripheral.identifier
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil) // Discover services
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        connectedPeripheralUUID = nil
        connectedPeripheral = nil
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Service found: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service) // Discover characteristics
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("🔍 Characteristic found: \(characteristic.uuid)")

                // Enable notifications for pill count characteristic
                if characteristic.uuid == pillCountCharacteristicUUID {
                    print("✅ Subscribing to pillCountCharacteristicUUID")
                    peripheral.setNotifyValue(true, for: characteristic)
                }

                // Optionally read once (if needed)
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
            }
        } else if let error = error {
            print("❌ Error discovering characteristics: \(error.localizedDescription)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let receivedString = String(decoding: data, as: UTF8.self)

            print("🔵 Characteristic updated: \(characteristic.uuid)")
            print("📦 Raw received string: \(receivedString)")

            if characteristic.uuid == pillCountCharacteristicUUID {
                print("✅ Matched pillCountCharacteristicUUID")

                if let pillValue = Int(receivedString) {
                    print("💊 Parsed pill count: \(pillValue)")
                    DispatchQueue.main.async {
                        self.pillCount = pillValue
                    }
                } else {
                    print("❌ Could not convert to Int")
                }
            }
        }
    }



    
    func startScanning() {
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        myCentral.stopScan()
    }
}
