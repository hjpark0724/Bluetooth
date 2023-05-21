//
//  ServiceViewModel.swift
//  Bluetooth
//
//  Created by HYEONJUN PARK on 2023/05/20.
//

import Foundation
import CoreBluetooth

class ServiceViewModel: ObservableObject, Identifiable {
    public var id: String {
        service?.uuid.uuidString ?? ""
    }
    
    public var isPrimary: Bool {
        service?.isPrimary ?? false
    }
    
    let service: CBService?
    @Published var characteristics: [CharacteristicViewModel] = []
    
    init(service: CBService?) {
        self.service = service
    }
    init() {
        service = nil
    }
    
    func discoverCharacteristics() {
        guard let service = service, let peripheral = service.peripheral else { return }
        peripheral.discoverCharacteristics(nil, for: service)
    }
    
}
