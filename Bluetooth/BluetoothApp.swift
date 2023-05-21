//
//  BluetoothApp.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import SwiftUI

@main
struct BluetoothApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BluetoothCenteral())
        }
    }
}
