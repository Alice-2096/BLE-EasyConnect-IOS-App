//
//  DisplayBLEdevices.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/20.
//

import SwiftUI

struct DisplayBLEdevices: View {
    @EnvironmentObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        VStack{
            Button(action: {
                bluetoothViewModel.scan()
            }, label: {
                Text("Click here to Scan for Peripherals")
            })
            ListOfScannedDevices(deviceNames: bluetoothViewModel.peripheralNames)
        }
    }
}

struct ListOfScannedDevices: View {
    var deviceNames: [String]
    
    var body: some View {
        if deviceNames.isEmpty {
            Text("No devices found")
        } else {
            List(deviceNames, id: \.self) { name in
                Text(name)
            }
        }
    }
}

struct DisplayBLEdevices_Previews: PreviewProvider {
    static var previews: some View {
        DisplayBLEdevices()
    }
}
