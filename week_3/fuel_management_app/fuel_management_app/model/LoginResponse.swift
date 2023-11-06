//
//  LoginResponse.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

struct LoginResponse: Codable {
    let token: String?
    let user: UserEntity?
}



