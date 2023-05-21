//
//  ContentView.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CentereralModeView()
                .tabItem {
                    Image(systemName: "macwindow")
                    Text("centeral")
                }
            PeripheralModeView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("peripheral")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
