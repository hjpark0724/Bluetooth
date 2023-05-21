//
//  CenteralView.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import SwiftUI

struct CentereralModeView: View {
    @EnvironmentObject var centeral: BluetoothCenteral
    @State var isScaning: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(centeral.peripherals, id: \.id) { viewModel  in
                        NavigationLink(destination: PeripheralView(viewModel: viewModel)) {
                            HStack() {
                                Image(systemName: "doc.text.magnifyingglass")
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(viewModel.name)
                                        .font(.subheadline)
                                    Text(viewModel.id)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Button {
                    
                    if !isScaning {
                        centeral.startScan()
                    } else {
                        centeral.stopScan()
                    }
                    isScaning.toggle()
                }label: {
                    
                        Text(isScaning ? "Stop" : "Scan")
                            .tint(.white)
                            .frame(width: 120, height: 46)
                            .background(isScaning ? .gray : .blue)
                            .cornerRadius(20)
                }
                
            }
            .navigationTitle("Bluetooth Peripherals")
        }
    }
}

struct CentereralModeView_Previews: PreviewProvider {
    static var previews: some View {
        CentereralModeView().environmentObject(BluetoothCenteral())
    }
}
