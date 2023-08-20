//
//  Characteristic.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/20.
//

import Foundation
import CoreBluetooth

class Characteristic: Identifiable {
    var id: UUID
    var characteristic: CBCharacteristic
    var description: String
    var uuid: CBUUID
    var readValue: String
    var service: CBService

    init(_characteristic: CBCharacteristic,
         _description: String,
         _uuid: CBUUID,
         _readValue: String,
         _service: CBService) {
        
        id = UUID()
        characteristic = _characteristic
        description = _description == "" ? "No Description" : _description
        uuid = _uuid
        readValue = _readValue == "" ? "No ReadValue" : _readValue
        service = _service
    }
}
