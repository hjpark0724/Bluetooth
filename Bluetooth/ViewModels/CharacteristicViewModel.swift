//
//  CharacteristicViewModel.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/20.
//

import Foundation
import CoreBluetooth
import Combine
class CharacteristicViewModel: ObservableObject, Identifiable {
    public var id: CBUUID {
        return characteristic.uuid
    }
    
    public var broadcast: Bool {
        return characteristic.properties.contains(.broadcast)
    }
    
    public var write: Bool {
        return characteristic.properties.contains(.write)
    }
    
    public var writeWithoutResponse: Bool {
        return characteristic.properties.contains(.writeWithoutResponse)
    }
    public var read: Bool {
        return characteristic.properties.contains(.read)
    }
    
    public var notify: Bool {
        return characteristic.properties.contains(.notify)
    }
    
    public var indicate: Bool {
        return characteristic.properties.contains(.indicate)
    }
    
    public var authenticatedSignedWrites: Bool {
        return characteristic.properties.contains(.authenticatedSignedWrites)
    }

    public var extendedProperties: Bool {
        return characteristic.properties.contains(.extendedProperties)
    }
    
    public var notifyEncryptionRequired: Bool {
        return characteristic.properties.contains(.notifyEncryptionRequired)
    }

    public var indicateEncryptionRequired: Bool {
        return characteristic.properties.contains(.indicateEncryptionRequired)
    }
    
    public var readAndNotify: String {
        if self.notify && self.read { return "Notify, Read" }
        else if self.notify { return "Notify" }
        else if self.read { return "Read" }
        return ""
    }
    
    let characteristic: CBCharacteristic
    init(characteristic: CBCharacteristic) {
        self.characteristic = characteristic
    }
    
    func setNotifyValue(_ enable: Bool) {
        guard let peripheral = characteristic.service?.peripheral else { return }
        peripheral.setNotifyValue(enable, for: self.characteristic)
    }
    func readValue() {
        guard let peripheral = characteristic.service?.peripheral else { return }
        peripheral.readValue(for: self.characteristic)
    }
}
