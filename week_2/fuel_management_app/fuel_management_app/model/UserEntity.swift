//
//  UserEntity.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import Foundation

struct UserEntity {
    var name:String
    var email:String
    var phone:String
    
    init(name: String, email: String, phone: String) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
