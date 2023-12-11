import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    let userData = BehaviorRelay<UserEntity?>(value: nil)
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }

            switch response{
            case .success(let data):
                switch endpoint {
                case .getUser:
                    if let data = data as? UserResponse{
                        self.userData.accept(data.data)
                        self.loadingState.accept(.finished)
                    }
                    break
                default:
                    break
                }
                break
            case .failure:
                self.loadingState.accept(.failed)
            }
        }
    }
}
