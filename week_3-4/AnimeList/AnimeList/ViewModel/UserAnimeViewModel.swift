import Foundation
import RxSwift
import RxCocoa

class UserAnimeViewModel {
    static let shared = UserAnimeViewModel()
    
    func postUserAnime(body: UserAnimeBody, completion: @escaping((Bool)-> Void)) {
        let endpoint = Endpoint.postUserAnime(params: body)
        APIManager.shared.fetchRequestBase2(endpoint: endpoint){(result: Result<StatusResponse, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
}
