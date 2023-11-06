//
//  UserEntity.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import Foundation

struct UserEntity: Codable {
    var id: String
    var username:String
    var email:String
    var address:String
    var urlImage: String
    var phone: String
}
