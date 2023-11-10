//
//  ApiManager.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    static let shared = APIManager()
    override init() {}
    
    func makeAPICall<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let headers = endpoint.headers
        
        // Add the API key to the headers
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: headers).validate().responseDecodable(of: T.self) { (response) in
            
            guard let item = response.value else {
                completion(.failure(response.error!))
                return
            }
            completion(.success(item))
        }
    }
}
