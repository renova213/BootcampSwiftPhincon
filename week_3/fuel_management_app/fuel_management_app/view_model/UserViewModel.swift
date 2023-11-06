//
//  UserViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

class UserViewModel {
    private var user: UserEntity?
    
    func setUserFromLoginResponse(loginResponse: LoginResponse) {
        
        self.user = loginResponse.user
    }
    
    func getUser() -> UserEntity{
        return user ?? UserEntity(id: "0", username: "-", email: "-", address: "-", urlImage: "-", phone: "-")
    }
}
