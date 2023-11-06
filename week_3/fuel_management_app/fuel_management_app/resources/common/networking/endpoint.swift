//
//  endpoint.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation
enum Endpoint {
    case login(param: LoginEntity)
    case register
    
    func path() -> String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        }
    }
    
    func method() -> String {
        switch self {
        case .login, .register:
            return "POST"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login:
           
            return nil
        case .register:
            return nil
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register:
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
            case .register:
                return nil
        }
    }
    
    func urlString() -> String {
        return BaseConstant.baseURL + path()
    }
}


