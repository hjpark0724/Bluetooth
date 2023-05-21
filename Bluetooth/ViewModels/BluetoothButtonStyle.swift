//
//  BluetoothButtonStyle.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/21.
//

import SwiftUI
struct BluetoothButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .background(configuration.isPressed ? .gray.opacity(0.5) : .blue.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
