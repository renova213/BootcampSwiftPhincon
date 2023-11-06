//
//  LoginViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

class AuthViewModel {
    func loginUser(login: LoginEntity, completion: @escaping(Result<LoginResponse, APIError>) -> Void) {
        let endpoint = Endpoint.login(param: login)
        
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: LoginResponse.self) { result in
            completion(result)
        }
    }
    
    func registerUser(register: RegisterEntity, completion: @escaping(Result<Void, APIError>) -> Void) {
        let endpoint = Endpoint.register(param: register)
        
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: LoginResponse.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
