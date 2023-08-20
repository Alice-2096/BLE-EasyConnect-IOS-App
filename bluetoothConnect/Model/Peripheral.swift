//
//  File.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/20.
//

import Foundation
import CoreBluetooth

class Peripheral: Identifiable {
    var id: UUID
    var peripheral: CBPeripheral
    var name: String
    var advertisementData: [String : Any]
    var rssi: Int
    var discoverCount: Int
    
    init(_peripheral: CBPeripheral,
         _name: String,
         _advData: [String : Any],
         _rssi: NSNumber,
         _discoverCount: Int) {
        id = UUID()
        peripheral = _peripheral
        name = _name
        advertisementData = _advData
        rssi = _rssi.intValue
        discoverCount = _discoverCount + 1
    }
}
