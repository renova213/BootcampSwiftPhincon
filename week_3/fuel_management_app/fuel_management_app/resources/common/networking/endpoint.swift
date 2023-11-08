//
//  endpoint.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation
enum Endpoint {
    case login(param: LoginEntity)
    case register(param: RegisterEntity)
    case getVehicles(param: String)
    case getUser
    case getUserByUsername(param: String)
    case updateUser(param: UserEntity)
    
    func path() -> String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .getVehicles(let param):
            return "/vehicle/userId=\(param)"
        case .getUser:
            return "/user"
        case .getUserByUsername(let param):
            return "/user/\(param)"
        case .updateUser(let param):
            return "/user/\(param.id)"
        }
    }
    
    func method() -> String {
        switch self {
        case .login, .register:
            return "POST"
        case .getVehicles, .getUser, .getUserByUsername:
            return "GET"
        case .updateUser:
            return "PUT"
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register, .getVehicles, .getUser, .updateUser, .getUserByUsername:
            let params:[String: Any]? = [
                "Content-Type": "application/json"]
            
            return params
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let param):
            let params: [String: Any] = [
                "username": param.username,
                "password": param.password
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        case .register(let param):
            let params: [String: Any] = [
                "username": param.username,
                "email": param.email,
                "password": param.password,
                "confirm_password": param.confirmPassword
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        case .getVehicles:
            return nil
        case .getUser:
            return nil
        case .getUserByUsername:
            return nil
        case .updateUser(let param):
            let params: [String: Any] = [
                "email": param.email,
                "address": param.address,
                "phone": param.phone,
            ]
            return try? JSONSerialization.data(withJSONObject: params)
        }
        
    }
    
    func urlString() -> String {
        return BaseConstant.baseURL + path()
    }
}


