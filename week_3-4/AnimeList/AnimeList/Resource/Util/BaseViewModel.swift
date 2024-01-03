import Foundation
import SystemConfiguration
import RxSwift
import RxCocoa

class BaseViewModel {
    internal let bag: DisposeBag = DisposeBag()
    
    let api = APIManager.shared
    let tokenHelper = TokenHelper.shared
    
    var loadingState = BehaviorRelay<StateLoading>(value: .initial)
    var loadingState2 = BehaviorRelay<StateLoading>(value: .initial)
    
    var toggle = BehaviorRelay<Bool>(value: false)
    var toggle2 = BehaviorRelay<Bool>(value: false)
    
    let errorMessage = BehaviorRelay<String>(value: "")
    

}

