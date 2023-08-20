//
//  Service.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/20.
//

import Foundation
import CoreBluetooth


class Service: Identifiable {
    var id: UUID
    var uuid: CBUUID
    var service: CBService

    init(_uuid: CBUUID,
         _service: CBService) {
        
        id = UUID()
        uuid = _uuid
        service = _service
    }
}
