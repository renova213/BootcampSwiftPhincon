import Foundation
import RxSwift
import RxCocoa

class AuthViewModel: BaseViewModel {
    var authToggle = BehaviorRelay<Bool>(value: true)
    
    func switchAuthToggle(state: Bool){
        authToggle.accept(state)
    }
}
