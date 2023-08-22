//
//  DisplayBLEdevices.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/20.
//

import SwiftUI
import CoreBluetooth

struct DisplayBLEdevices: View {
    @EnvironmentObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        VStack{
            Button(action: {
                bluetoothViewModel.scan()
            }, label: {
                Text("Click here to Scan for Peripherals")
            })
            ListOfScannedDevices(peripherals: bluetoothViewModel.discoveredPeripherals)
        }
        .navigationBarTitle("Scanned Devices")
    }
}

struct ListOfScannedDevices: View {
    @EnvironmentObject var bluetoothViewModel: BluetoothViewModel
    var peripherals: [CBPeripheral]
    
    var body: some View {
        if peripherals.isEmpty {
            Text("No devices found")
        } else {
            List(peripherals, id: \.self) { device in
                NavigationLink(destination: DeviceDetailsView(device: device)) {
                    Text(device.name ?? "Unknown Device")
                }
                .onTapGesture {
                    bluetoothViewModel.connectedPeripheral = device
                }
            }
        }
    }
}

struct DisplayBLEdevices_Previews: PreviewProvider {
    static var previews: some View {
        DisplayBLEdevices()
    }
}
