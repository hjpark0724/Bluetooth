//
//  BluetoothViewModel.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/19.
//

import Foundation
import CoreBluetooth
import Combine
class BluetoothPeripheral: NSObject, ObservableObject {
    @Published var receivedMessage: String = ""
    private var peripheralManger = CBPeripheralManager(delegate: nil, queue: DispatchQueue.global(qos: .userInteractive))
    public let serviceIdentifier = CBUUID(string: "87BBBAF2-7BA9-4117-9D65-68071ADD43F6")
    public let characteristicIdentifier1 = CBUUID(string: "4C03869A-DE13-4621-9329-89FC98968F86")
    public let characteristicIdentifier2 = CBUUID(string: "4C03869A-DE13-4621-9329-89FC98968F87")
    public let characterValue = "154C"
    public var characterstics: [CBMutableCharacteristic] = []
    override init() {
        super.init()
        print("service id: \(serviceIdentifier.uuidString)")
        peripheralManger.delegate = self
    }
    
    func addService() {
        let service = CBMutableService(type: serviceIdentifier, primary: true)
        let characterstics =  [
            CBMutableCharacteristic(type: characteristicIdentifier1,
                                    properties: [.notify, .read, .write],
                                    value: nil,
                                    permissions: [.readable, .writeable]),
            
            CBMutableCharacteristic(type: characteristicIdentifier2,
                                    properties: [.read,],
                                    value: characterValue.data(using: .utf8),
                                    permissions: [.readable]),
                               
        ]
        self.characterstics = characterstics
        service.characteristics = characterstics
    
        peripheralManger.add(service)
    }
    
    func advertise() {
        print(peripheralManger.isAdvertising)
        peripheralManger.startAdvertising(
            [CBAdvertisementDataLocalNameKey : "iOS Peripheral",
         CBAdvertisementDataServiceUUIDsKey : [serviceIdentifier] ])
    }
    
    func stopAdevertise() {
        peripheralManger.stopAdvertising()
    }
    
    func send(request: String) {
       
    }
}

extension BluetoothPeripheral: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            self.addService()
        default:
            ()
        }
        
    }
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("did Start Advertising")
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("service added")
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("subscribe: \(central.description)")
        let hello = "hello"
        guard let target = characterstics.first(where: {$0.uuid == characteristic.uuid}) else { return }
        peripheralManger.updateValue(hello.data(using: .utf8)!, for: target, onSubscribedCentrals: [central])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceive Read")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        if let value = requests.first?.value {
            receivedMessage = String(data: value, encoding: .utf8)!
        }
    }
}
