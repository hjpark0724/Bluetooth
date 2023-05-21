//
//  PeripheralViewModel.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import Foundation
import CoreBluetooth
import Combine

class PeripheralViewModel: NSObject, ObservableObject, Identifiable {
    @Published var isConnected: Bool = false
    @Published var services: [ServiceViewModel] = []
    var id: String {
        return peripheral?.identifier.uuidString ?? ""
    }
    var name: String {
        return peripheral?.name ?? ""
    }
    
    let peripheral: CBPeripheral?
    init(peripheral: CBPeripheral?) {
        self.peripheral = peripheral
        super.init()
        self.peripheral?.delegate = self
    }
    
    func discoverCharacteristics(for service: CBService) {
       // peripheral?.discoverCharacteristics(nil, for: service)
        peripheral?.discoverCharacteristics(nil, for: service)
    }
    
    static public func == (lhs: PeripheralViewModel, rhs: PeripheralViewModel) -> Bool {
        guard let lhs = lhs.peripheral, let rhs = rhs.peripheral else { return false }
        return lhs == rhs
    }
}

extension PeripheralViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("read rssi :\(RSSI)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = true
            print("did discover services:\(peripheral.services!.count)")
            peripheral.services?.forEach{ peripheral.discoverCharacteristics(nil, for: $0)}
            self.services = peripheral.services?.compactMap{ServiceViewModel(service: $0)} ?? []
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            if let error = error {
                print("discover characteristics error:\(error)")
            }
            return
        }
        guard let index = services.firstIndex(where: {$0.service == service}) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.services[index].characteristics = characteristics.compactMap{CharacteristicViewModel(characteristic: $0)}
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value as NSData? else {
            print("update value error")
            return
        }
        
        print("update value: \(characteristic.isNotifying): \(value.description)")
    }
}


