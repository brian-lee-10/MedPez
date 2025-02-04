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

    override init() {
        super.init()
        myCentral = CBCentralManager(delegate:self, queue: nil)
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
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "No error information")")
        connectedPeripheralUUID = nil
        connectedPeripheral = nil
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        connectedPeripheralUUID = nil
        connectedPeripheral = nil
    }

    func startScanning() {
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        myCentral.stopScan()
    }
}
