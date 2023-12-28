import Foundation
import RxSwift
import RxCocoa

class AuthViewModel: BaseViewModel {
    static let shared = AuthViewModel()
    var authToggle = BehaviorRelay<Bool>(value: true)
    
    func postData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        switch endpoint {
        case .postLogin, .postLoginGoogle:
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
                    case .postLogin, .postLoginGoogle:
                        if let data = data as? LoginResponse{
                            if let token = data.token {
                                self.storeToken(with: token)
                            }
                            if let userData = data.user{
                                UserDefaultHelper.shared.saveUserIDToUserDefaults(userID: userData.id)
                            }
                            self.loadingState.accept(.finished)
                        }
                        break
                    default:
                        self.loadingState2.accept(.finished)
                        break
                    }
                    break
                case .failure(let error):
                    if let error = error as? CustomError {
                        self.errorMessage.accept(error.message)
                    }
                    switch endpoint {
                    case .postLogin, .postLoginGoogle:
                        self.loadingState.accept(.failed)
                    default:
                        self.loadingState2.accept(.failed)
                    }
                }
            }
        }
    }
}
