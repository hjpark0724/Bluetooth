//
//  PeripheralView.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import SwiftUI
import CoreBluetooth
struct PeripheralView: View {
    @EnvironmentObject var centralManager: BluetoothCenteral
    @ObservedObject var viewModel: PeripheralViewModel
    @State var time = 0.0
    init(viewModel: PeripheralViewModel) {
        self.viewModel = viewModel
    }
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "timelapse", variableValue: time)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
                    .fontWeight(.thin)
                    .onReceive(timer) { _ in
                        if time < 1.0
                        {
                            time += 0.1
                        } else {
                            timer.upstream.connect().cancel()
                        }
                    }
                    .padding()
                Text("Connecting")
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke()
                .foregroundStyle(
                    .linearGradient(colors: [.white.opacity(0.5), .clear, .white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
            .shadow(color: .black.opacity(0.3), radius: 10, y: 10)
            .frame(maxWidth: 500)
            .opacity(viewModel.isConnected ? 0 : 1)
            if viewModel.isConnected {
                Form {
                    Section {
                        Text(viewModel.name)
                    } header: {
                        Text("Peripheral information")
                    }
                    Section {
                        ForEach(viewModel.services, id: \.id) { service in
                            NavigationLink(destination: CharacteristicsView(service: service))
                                           {
                                VStack (alignment: .leading){
                                    Text(service.id)
                                        .font(.subheadline)
                                    Text("Primary: \(service.isPrimary ? "true" : "false")")
                                        .font(.footnote)
                                }
                            }
                        }
                    } header: {
                        Text("Services")
                    }
                    
                }
            }
        }
        .navigationTitle("\(viewModel.name)")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.isConnected)
        .task {
            if let peripheral = self.viewModel.peripheral, peripheral.state == .disconnected {
                centralManager.connect(peripheral: peripheral)
            }
        }
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralView(viewModel: PeripheralViewModel(peripheral: nil)).environmentObject(BluetoothCenteral())
    }
}

extension CBPeripheralState : CustomStringConvertible {
    public var description: String {
        switch self {
        case .connected:
            return "connected"
        case .connecting:
            return "connecting"
        case .disconnecting:
            return "disconnecting"
        case .disconnected:
            return "disconnected"
        default:
            return ""
        }
    }
}
