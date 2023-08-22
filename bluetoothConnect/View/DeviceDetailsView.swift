//
//  DeviceDetailsView.swift
//  bluetoothConnect
//
//  Created by apple on 2023/8/21.
//

import SwiftUI

struct DeviceDetailsView: View {
    @State private var inputValue: String = ""
    @State private var outputValue: String = ""
    var deviceName: String
    var deviceUUID: UUID? = nil
        
    var body: some View {
        VStack {
            Text("Device Information")
                .font(.title)
                .padding()
            
            // Display Device Name and UUID
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Device Name \(deviceName)")
                Text("Device UUID: \(deviceUUID?.uuidString ?? "No UUID available")")
            }
            .padding()
            
            Divider()
            
            // DigitalWrite Panel
            VStack {
                Text("Write to this BLE Device")
                    .font(.headline)
                
                TextField("Input Value", text: $inputValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Code to send input value to the BLE device
                    // You can use the 'inputValue' variable here
                }) {
                    Text("Enter")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            // Digital Output Panel
            VStack {
                Text("Digital Output")
                    .font(.headline)
                Text("Output data: \(outputValue)")
                    .padding()
            }
            .padding()
        }
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailsView(deviceName: "Test Device", deviceUUID:  UUID())
    }
}
