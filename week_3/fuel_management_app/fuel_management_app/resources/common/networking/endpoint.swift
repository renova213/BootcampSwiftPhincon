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
        }
    }
    
    func method() -> String {
        switch self {
        case .login, .register:
            return "POST"
        case .getVehicles, .getUser:
            return "GET"
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register, .getVehicles, .getUser:
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
        }
        
    }
    
    func urlString() -> String {
        return BaseConstant.baseURL + path()
    }
}


