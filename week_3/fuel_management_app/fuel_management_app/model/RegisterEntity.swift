//
//  RegisterEntity.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

struct RegisterEntity: Codable {
    let username, email, password, confirmPassword: String
}
