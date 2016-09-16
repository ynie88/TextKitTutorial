//
//  BluetoothDevice.swift
//  BluetoothTutorial
//
//  Created by Yuchen Nie on 9/16/16.
//  Copyright © 2016 Yuchen Nie. All rights reserved.
//

import Foundation
import CoreBluetooth
import QuartzCore

struct UUIDs {
    static let deviceInfoService = "180A"
    static let heartRateServiceID = "180D"
    static let heartRateMeasurement = "2A37"
    static let bodyLocationCharacteristic = "2A38"
    static let manufacturerNameCharacteristic = "2A29"
}

enum State {
    case Connect
}

protocol BluetoothDelegate {
    
}

class CentralManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager!
    var delegate:BluetoothDelegate?
    var didScan = true
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if didScan {
            scan()
        } else {
            print(central.state)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
    }
    
    private func scan() {
        let heartRateService = CBUUID(string: UUIDs.deviceInfoService)
        let deviceInfoservice = CBUUID(string: UUIDs.heartRateServiceID)
        manager.scanForPeripherals(withServices: [heartRateService, deviceInfoservice], options: nil)
    }
}

class HeartRateCollectionClass {
    var delegate:BluetoothDelegate?
    func getHeartBPMData(with characteristic:CBCharacteristic, and error:NSError) {
        
    }
    
    func getManufacturerName(with characteristic:CBCharacteristic) {
        
    }
    func getBodyLocation(with characteristic:CBCharacteristic) {
        
    }
    func didHeartBeat() {
        
    }
}
