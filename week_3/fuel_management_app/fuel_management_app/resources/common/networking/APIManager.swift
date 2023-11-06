//
//  APIManager.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

struct APIError: Error {
    let message: String
}

final class APIManager{
    static let shared = APIManager()
    
    private init(){}
    
    
    public func fetchRequest<T: Codable>(endpoint: Endpoint, expecting type: T.Type, completion: @escaping(Result<T, APIError>)-> Void){
        
        guard let urlRequest = self.request(endpoint: endpoint) else {
            completion(.failure(APIError(message: "url tidak ditemukan")))
            return }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let data = data, error == nil else {
                completion(.failure(APIError(message: "URL Tidak Ditemukan")))
                return
            }
            
           
            
            switch httpResponse.statusCode {
                
            case 200..<300:
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError(message: "\(error)")))
                }
            case 401:
                let errorMessage = self.extractErrorMessage(from: data)
                completion(.failure(APIError(message: "\(errorMessage)"))) // Unauthorized error
            case 404:
                let errorMessage = self.extractErrorMessage(from: data)
                completion(.failure(APIError(message: "\(errorMessage)"))) // Not Found error
            default:
                let errorMessage = self.extractErrorMessage(from: data)
                completion(.failure(APIError(message: "\(errorMessage)"))) // Other errors
            }
        }.resume()
        
    }
    
    public func request(endpoint: Endpoint) -> URLRequest? {
        var url: URL {
            return URL(string: endpoint.urlString()) ?? URL(string: "")!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method()
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func extractErrorMessage(from data: Data) -> String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let errorMessage = jsonObject["message"] as? String else {
            return "Unknown Error"
        }
        return errorMessage
    }
}
