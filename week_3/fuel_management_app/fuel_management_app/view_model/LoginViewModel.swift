//
//  LoginViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

class LoginViewModel {
    func loginUser(username: String, password: String, completion: @escaping(Result<LoginResponse, APIError>) -> Void) {
        let loginEntity = LoginEntity(username: username, password: password)
        let endpoint = Endpoint.login(param: loginEntity)
               
               APIManager.shared.fetchRequest(endpoint: endpoint, expecting: LoginResponse.self) { result in
                   completion(result)
               }
    }
}
