//
//  CharacteristicView.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/20.
//

import SwiftUI

struct CharacteristicsView: View {
    @ObservedObject var viewModel: ServiceViewModel
    
    init(service: ServiceViewModel) {
        self.viewModel = service
    }

    var body: some View {
        ZStack {
            Form {
                ForEach(viewModel.characteristics, id: \.id) { characteristic in
                    Section {
                        if characteristic.read {
                            HStack {
                                Text("Read")
                                Spacer()
                                Button{
                                    characteristic.readValue()
                                }label: {
                                    Text("Read")
                                        .frame(width: 64, height: 42)
                                }
                                
                            }
                        }
                        if characteristic.notify {
                            HStack {
                                Text("Notify")
                                Spacer()
                                Button{
                                    characteristic.setNotifyValue(true)
                                }label: {
                                    Text("Notify")
                                        .frame(width: 64, height: 42)
                                }
                            }
                        }
                        if characteristic.write {
                            Text("Write")
                        }
                        if characteristic.writeWithoutResponse {
                            Text("WriteWithoutResponse")
                        }
                        if characteristic.broadcast {
                            Text("Brodcast")
                        }
                    } header: {
                        Text("\(characteristic.id.uuidString)")
                    }
                }
                .buttonStyle(BluetoothButtonStyle())
            }
        }
        .navigationTitle("Characteristics")
        .navigationBarTitleDisplayMode(.inline)
        .task {
        }
    }
}

struct CharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        CharacteristicsView(service: ServiceViewModel())
    }
}
