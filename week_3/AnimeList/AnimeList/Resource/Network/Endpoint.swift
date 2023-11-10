//
//  Endpoint.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import Foundation
import Alamofire



enum Endpoint {
    case getAnime
    
    func path() -> String {
        switch self {
        case .getAnime:
            return "/anime"
            
        }
    }
    
    func method() -> HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAnime:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return params
    }
    
    func urlString() -> String {
        return BaseConstant.baseURL + self.path()
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getAnime:
            return URLEncoding.queryString
        }
    }
}
