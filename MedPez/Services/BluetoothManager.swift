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
    @Published var batteryLevel: Int = 0
    let batteryLevelCharacteristicUUID = CBUUID(string: "beb5483e-0002-4688-b7f5-ea07361b26a8")

    override init() {
        super.init()
        // myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func initializeCentralManager() {
        if myCentral == nil {
            myCentral = CBCentralManager(delegate: self, queue: nil)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedOn = central.state == .poweredOn
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
        peripheral.discoverServices(nil) // Discover service
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
                    
                    peripheral.readValue(for: characteristic)
                }
                
                if characteristic.uuid == batteryLevelCharacteristicUUID {
                    print("✅ Subscribing to Battery UUID")
                    peripheral.setNotifyValue(true, for: characteristic)
                    peripheral.readValue(for: characteristic) // trigger initial read
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
            
            if characteristic.uuid == batteryLevelCharacteristicUUID {
                print("✅ Matched batteryLevelCharacteristicUUID")

                if let batteryString = String(data: characteristic.value ?? Data(), encoding: .utf8),
                   let batteryPercent = Int(batteryString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    print("🔋 Battery level received: \(batteryPercent)%")
                    DispatchQueue.main.async {
                        self.batteryLevel = batteryPercent
                    }
                }
            }

        }
    }
    
    func sendNextDoseTime(_ timeString: String) {
        guard let peripheral = connectedPeripheral else { return }

        let nextDoseUUID = CBUUID(string: "beb5483e-0003-4688-b7f5-ea07361b26a8")

        // Discover the characteristic and write the value
        if let services = peripheral.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == nextDoseUUID {
                            if let data = timeString.data(using: .utf8) {
                                peripheral.writeValue(data, for: characteristic, type: .withResponse)
                                print("🕐 Sent next dose time: \(timeString)")
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    func sendTodayDoseData(total: Int, completed: Int) {
        guard let peripheral = connectedPeripheral else { return }

        // UUIDs must match those in the ESP32 sketch
        let totalUUID = CBUUID(string: "beb5483e-0004-4688-b7f5-ea07361b26a8")
        let completedUUID = CBUUID(string: "beb5483e-0005-4688-b7f5-ea07361b26a8")

        if let service = peripheral.services?.first {
            for char in service.characteristics ?? [] {
                if char.uuid == totalUUID {
                    let value = "\(total)".data(using: .utf8)!
                    peripheral.writeValue(value, for: char, type: .withResponse)
                } else if char.uuid == completedUUID {
                    let value = "\(completed)".data(using: .utf8)!
                    peripheral.writeValue(value, for: char, type: .withResponse)
                }
            }
        }
    }

    func sendAlarmTrigger() {
        guard let peripheral = connectedPeripheral else { return }

        let alarmUUID = CBUUID(string: "beb5483e-0006-4688-b7f5-ea07361b26a8")

        if let services = peripheral.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == alarmUUID {
                            let data = "true".data(using: .utf8)!
                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
                            print("🚨 Alarm trigger sent via BLE")
                            return
                        }
                    }
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

