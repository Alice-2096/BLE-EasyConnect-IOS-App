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
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func scan(){
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    //central manager calls this when it discovers a peripheral while scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("discovering device")
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            if let name = peripheral.name {
                peripheralNames.append(name)
            }
        }
    }
    
    //make connections to the specified peripheral by name
    func connectToPeripheral(withName name: String){
        for peripheral in discoveredPeripherals {
            if peripheral.name == name {
                centralManager?.connect(peripheral, options: nil)
            }
        }
    }
    
    //after connected to peripheral, discover its services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil) //discover all services
        peripheral.delegate = self
    }
    
}

extension BluetoothViewModel: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else {
//            return
//        }

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
}


