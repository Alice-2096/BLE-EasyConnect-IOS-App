//
//  DeviceDetailsView.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/21.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailsView: View {
    @EnvironmentObject var bluetoothViewModel: BluetoothViewModel
    var device: CBPeripheral? = nil
    
    var body: some View {
        VStack {
            Text("Device Information")
                .font(.title)
                .padding()
            
            // Display Device Name and UUID
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Device Name \(device?.name ?? "No Name available")")
                Text("UUID: \("Not Found")")  //how to access the uuid of a CBperipheral?
            }
            .padding()
            
            Divider()
            
            //Device Services and Characteristics
            VStack {
                Text("Device Services and Characteristics")
                    .font(.headline)
                
                List {
                    if let service = device?.services {
                        ForEach(service, id: \.self){ serv in
                            Section(header: Text("Service: \(serv.uuid.uuidString)")){
                                if let chars = serv.characteristics {
                                    ForEach(chars, id: \.self){ char in
                                        NavigationLink(destination: CharacteristicDetailsView(characteristic: char)) {
                                            Text("Characteristic: \(char.uuid.uuidString)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct DeviceDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceDetailsView(deviceName: "Test Device", deviceUUID:  UUID())
//    }
//}
