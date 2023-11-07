//
//  VehicleViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 07/11/23.
//

import Foundation


class VehicleViewModel {
    
    var data: [VehicleEntity] = []
    
    func getVehicles(userId: String) {
        let endpoint = Endpoint.getVehicles(param: userId)
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: [VehicleEntity].self) { result in
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let err):
                print(err)
            }
            
        }
    }
}

