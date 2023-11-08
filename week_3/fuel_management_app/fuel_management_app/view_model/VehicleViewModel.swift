//
//  VehicleViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 07/11/23.
//

import Foundation
import RxSwift
import RxCocoa


class VehicleViewModel {
    private let dataRelayVehicles = BehaviorRelay<[VehicleEntity]>(value: [])
    
    var vehicles: Observable<[VehicleEntity]>{
        return dataRelayVehicles.asObservable()
    }
    
    private let selectedVehicleSubject = PublishSubject<String>()
    
    var selectedVehicleObservable: Observable<String> {
        return selectedVehicleSubject.asObservable()
    }
    
    func getVehicles(userId: String) {
        let endpoint = Endpoint.getVehicles(param: userId)
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: [VehicleEntity].self) {[weak self]  result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                self.dataRelayVehicles.accept(data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func selectedVehicle(id: String){
        selectedVehicleSubject.onNext(id)
    }
}

