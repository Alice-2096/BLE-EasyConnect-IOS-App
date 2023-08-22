import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    var centralManager: CBCentralManager?
    
    @Published var connectedPeripheral: CBPeripheral? {
        didSet {
            if let peripheral = connectedPeripheral {
                connectToPeripheral(peripheral)
            }
        }
    }
    
    @Published var connectedPeripheralServices: [CBService] = []
    @Published var serviceToCharacteristicsMap: [CBUUID: [CBCharacteristic]] = [:] //map services UUIDs to characteristics
    
    @Published var writableCharacteristic: CBCharacteristic?
    @Published var writeResponse: String = ""
    
    @Published var discoveredPeripherals : [CBPeripheral] = []
    @Published var peripheralNames : [String] = []
   
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main) //CBCentralManager will scans for, discovers, connects to, and manages peripherals
    }
    
    func scan(){
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    //make connections to the specified peripheral
    func connectToPeripheral(_ peripheral: CBPeripheral){
        if !discoveredPeripherals.contains(peripheral){
            return
        }
        centralManager?.connect(peripheral, options: nil)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    //central manager calls this when its state updates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    //central manager calls this when it discovers a peripheral while scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("discovering device")
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    //after connected to peripheral, discover its services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil) //discover all services
    }
    
}

//define some callback functions related to the peripheral's state change (being discovered) and interaction with the app (write, read operation)
extension BluetoothViewModel: CBPeripheralDelegate {
    // executed after discover services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            return //handle error
        }

        for service in peripheral.services ?? [] {
            connectedPeripheralServices.append(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    // execute after discover characteristics of a service - populate the map
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            return //handle error
        }
        // update service-char map
        if let characteristics = service.characteristics {
            serviceToCharacteristicsMap[service.uuid] = characteristics
        }
    }

    //retrieving the specified characteristic’s value succeeded, or that the characteristic’s value changed.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("updated value for characteristic")
    }

    //after writing to a characteristic, update writeResponse var
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic,error: Error?){
        guard error == nil else {
            print("Error writing value for characteristic: \(error!.localizedDescription)")
            return //handle error
        }
        
        if let responseValue = characteristic.value {
            if let responseString = String(data: responseValue, encoding: .utf8){
                writeResponse = responseString.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
}



/*
 Services:
    A service is a logical container that groups together related data and behavior of a Bluetooth device. It is identified by a unique UUID which
    defines its type and purpose
 
 Characteristic:
    A characteristic is a data value that represents the value of a sensor for a specific feature of a Bluetooth device.
 
 Descriptor:
    descriptors are metadata that provide additional information about characteristics.
    Like characteristics, descriptors are identified by unique UUIDs.
 
 Client Configuration Descriptor:
    One important type of descriptor is the Client Configuration Descriptor. This descriptor is commonly used to enable or disable notifications or
    indications for a characteristic. By writing a specific value to this descriptor, a client (such as a smartphone app) can request notifications or
    indications whenever the characteristic's value changes.

 */
