import Foundation
import RxSwift
import RxCocoa

class AuthViewModel: BaseViewModel {
    var authToggle = BehaviorRelay<Bool>(value: true)
    var errorMessage = BehaviorRelay<CustomError?>(value: nil)
    
    func postData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        switch endpoint {
        case .postLogin:
            loadingState.accept(.loading)
            break
        case .postRegister:
            loadingState2.accept(.loading)
            break
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
                guard let self = self else { return }
                
                switch response{
                case .success(let data):
                    switch endpoint {
                    case .postLogin:
                        if let data = data as? LoginResponse{
                            if let token = data.token {
                                self.storeToken(with: token)
                            }
                            if let userData = data.user{
                                self.saveUserIDToUserDefaults(userID: userData.id)
                            }
                        }
                        self.loadingState.accept(.finished)
                        break
                    case .postRegister:
                        self.loadingState2.accept(.finished)
                        break
                    default:
                        break
                    }
                    break
                case .failure(let error):
                    switch endpoint {
                    case .postLogin:
                        if let error = error as? CustomError {
                            self.errorMessage.accept(error)
                        }
                        self.loadingState.accept(.failed)
                    case .postRegister:
                        if let error = error as? CustomError {
                            self.errorMessage.accept(error)
                        }
                        self.loadingState2.accept(.failed)
                    default:
                        break
                    }
                }
            }
        }
    }
}
