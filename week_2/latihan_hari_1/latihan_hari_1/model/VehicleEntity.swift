//
//  carEntity.swift
//  latihan_hari_4
//
//  Created by Phincon on 27/10/23.
//

import Foundation

struct VehicleEntity {
    var vehicleType: String
    var vehicleName: String
    var platNumber: String
    
    init(vehicleName: String, platNumber: String, vehicleType: String) {
        self.vehicleType = vehicleType
        self.vehicleName = vehicleName
        self.platNumber = platNumber
    }
    
    static let vehicles: [[VehicleEntity]] = [
        [
        VehicleEntity(vehicleName: "HYUNDAI", platNumber: "F 123 AA", vehicleType: "Car"),
        VehicleEntity(vehicleName: "TOYOTA", platNumber: "F 123 AA", vehicleType: "Car"),
        VehicleEntity(vehicleName: "MITSUBISHI", platNumber: "F 123 AA", vehicleType: "Car"),
        VehicleEntity(vehicleName: "SUZUKI", platNumber: "F 123 AA", vehicleType: "Car"),
        VehicleEntity(vehicleName: "WULING", platNumber: "F 123 AA", vehicleType: "Car"),
        VehicleEntity(vehicleName: "CHERY", platNumber: "F 123 AA", vehicleType: "Car")
        ],
        [
        VehicleEntity(vehicleName: "PCJ-600", platNumber: "F 123 AA", vehicleType: "Bike"),
        VehicleEntity(vehicleName: "NRG-500", platNumber: "F 123 AA", vehicleType: "Bike"),
        VehicleEntity(vehicleName: "Freeway", platNumber: "F 123 AA", vehicleType: "Bike"),
        ],
        [
        VehicleEntity(vehicleName: "DAIMLER", platNumber: "F 123 AA", vehicleType: "Bus"),
        VehicleEntity(vehicleName: "KING LONG", platNumber: "F 123 AA", vehicleType: "Bus"),
        VehicleEntity(vehicleName: "ZHONG TONG", platNumber: "F 123 AA", vehicleType: "Bus"),
        VehicleEntity(vehicleName: "HIGER", platNumber: "F 123 AA", vehicleType: "Bus")
        ]
    ]
}
