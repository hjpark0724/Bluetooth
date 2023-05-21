//
//  BluetoothCenteral.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import Foundation
import Combine
import CoreBluetooth

class BluetoothCenteral : NSObject, ObservableObject {
    let centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue.global(qos: .userInitiated))
    let serviceId = CBUUID(string: "87BBBAF2-7BA9-4117-9D65-68071ADD43F6")
    @Published var peripherals: [PeripheralViewModel] = []
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    func startScan() {
        
        //centralManager.scanForPeripherals(withServices:[serviceId])
        centralManager.scanForPeripherals(withServices:nil)
        //centralManager.registerForConnectionEvents()
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        print("connecting: \(peripheral.name!)")
        centralManager.connect(peripheral)
    }
    func disconnect(_ peripheral: CBPeripheral) {
        guard let services = peripheral.services else { return }
        for service in services {
            for characteristic in service.characteristics ?? [] {
                if characteristic.isNotifying {
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
    }
    
    func cancelPeripheralConnection(_ peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
}


extension BluetoothCenteral: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        DispatchQueue.main.async {
            guard RSSI.intValue >= -70, let name = peripheral.name, !self.peripherals.contains(where: { $0.peripheral == peripheral }) else {
               // print("\(peripheral.id) is contains")
                return
            }
            print(name)
            for key in advertisementData.keys {
                print("key:\(key), value:\(advertisementData[key]!)")
            }
            print()
            /*
            if let timeInterval = advertisementData["kCBAdvDataTimestamp"] as? TimeInterval {
                
                let date = Date(timeIntervalSinceReferenceDate: timeInterval)
                print(date.formatted())
            }
            if let serviceids = advertisementData["kCBAdvDataServiceUUIDs"] as? Array<CBUUID> {
                for serviceid in serviceids {
                    print(serviceid.uuidString)
                }
            }
            print(RSSI)
            */
            self.peripherals.append(PeripheralViewModel(peripheral: peripheral) )
        }
    }
    
//    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
//        print("event occur\n")
//        switch event {
//        case .peerConnected:
//            peripherals.insert(peripheral)
//        case .peerDisconnected:
//            if let index = peripherals.firstIndex(where: { $0 == peripheral }) {
//                peripherals.remove(at: index)
//            }
//        default:
//            ()
//        }
//    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let viewModel = peripherals.first(where: { $0.peripheral == peripheral }) {
            //peripheral.discoverServices([serviceId])
            peripheral.discoverServices(nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("\(peripheral.name ?? peripheral.identifier.uuidString) connect fail")
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("\(peripheral.name ?? peripheral.identifier.uuidString) is disconnectd")
    }
}

extension CBPeripheral : Identifiable, ObservableObject {
    public var id: UUID {
        return self.identifier
    }
    
}
