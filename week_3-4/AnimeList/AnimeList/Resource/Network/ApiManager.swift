import Foundation
import Alamofire

public enum HTTPStatusCode: Int {
    case success = 200
    case created = 201
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflic = 409
    case limit = 429
    case internalServerError = 500
    case serviceUnvaliable = 503
}

class APIManager {
    static let shared = APIManager()
    
    public func fetchMultipartRequest<T: Codable>(endpoint: Endpoint, image: Data, completion: @escaping(Result<T, Error>)-> Void){
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("form-data".data(using: .utf8 ,allowLossyConversion: false)!, withName: "Content-Disposition")
                
                multipartFormData.append(image, withName: "image",fileName: "image.jpg")
            },
            to: endpoint.urlString(),
            method: endpoint.method(),
            headers: endpoint.headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let decodedObject):
                    completion(.success(decodedObject))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                       let httpStatusCode = HTTPStatusCode(rawValue: statusCode),
                       let data = response.data,
                       let errorResponse = try? JSONDecoder().decode(StatusResponse.self, from: data) {
                        
                        let customError = CustomError(statusCode: httpStatusCode, message: errorResponse.message)
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    public func fetchRequest<T: Codable>(endpoint: Endpoint, completion: @escaping(Result<T, Error>)-> Void){
        guard NetworkReachabilityManager()!.isReachable else {
            let noInternetError = CustomError(statusCode: HTTPStatusCode.serviceUnvaliable, message: "No internet connection")
                completion(.failure(noInternetError))
                return
            }
        
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let decodedObject):
                completion(.success(decodedObject))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode,
                   let httpStatusCode = HTTPStatusCode(rawValue: statusCode),
                   let data = response.data,
                   let errorResponse = try? JSONDecoder().decode(StatusResponse.self, from: data) {
                    
                    let customError = CustomError(statusCode: httpStatusCode, message: errorResponse.message)
                    completion(.failure(customError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
