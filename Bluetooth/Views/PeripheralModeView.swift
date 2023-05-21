//
//  PeripheralView.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import SwiftUI

struct PeripheralModeView: View {
    let peripheral = BluetoothPeripheral()
    @State var isAdvertising: Bool = false
    var body: some View {
        VStack {
            Text("service:\(peripheral.serviceIdentifier)")
                .font(.caption)
                .fontWeight(.semibold)
            Button {
                if isAdvertising == false {
                    peripheral.advertise()
                } else {
                    peripheral.stopAdevertise()
                }
                
                isAdvertising.toggle()
            }label: {
                Text(!isAdvertising ? "Advertise" : "Stop")
                    .tint(.white)
                    .frame(width: 120, height: 50)
                    .background(Color(.blue))
                    .cornerRadius(20)
            }
        }
    }
}

struct PeripheralModeView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralModeView()
    }
}
