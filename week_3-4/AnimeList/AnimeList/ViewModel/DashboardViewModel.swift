import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel {
    static let shared = DashboardViewModel()
    
    let isFirstFetchData = BehaviorRelay<Bool>(value: true)
    
    func changeFirstFetchData(bool: Bool){
        isFirstFetchData.accept(bool)
    }
}
