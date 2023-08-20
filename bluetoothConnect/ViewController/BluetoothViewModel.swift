import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    var centralManager: CBCentralManager?
    @Published var connectedPeripheral: CBPeripheral?
    @Published var discoveredPeripherals : [CBPeripheral] = []
    @Published var peripheralNames : [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main) //CBCentralManager will scans for, discovers, connects to, and manages peripherals
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    //central manager calls this when its state updates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("scanning for peripheral")
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            print("state == off")
        }
    }
    
    func scan(){
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
        print("scanning for peripheral")
    }
    
    //central manager calls this when it discovers a peripheral while scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("discovering device")
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            peripheralNames.append(peripheral.name ?? "Unknown device")
        }
    }
    
    //after connected to peripheral, discover all its services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
//      peripheral.delegate = self
    }
    
}
//
//extension BluetoothViewModel: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else {
//            return
//        }
//
//        targetService = services.first
//        if let service = services.first {
//            targetService = service
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else {
//            return
//        }
//
//        for characteristic in characteristics {
//            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
//                writableCharacteristic = characteristic
//            }
//            peripheral.setNotifyValue(true, for: characteristic)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let data = characteristic.value, let delegate = delegate else {
//            return
//        }
//
//        delegate.simpleBluetoothIO(simpleBluetoothIO: self, didReceiveValue: data.int8Value())
//    }
//}


