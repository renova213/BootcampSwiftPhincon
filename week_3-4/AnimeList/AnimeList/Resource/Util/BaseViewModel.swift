import Foundation
import SystemConfiguration
import RxSwift
import RxCocoa

enum StateLoading: Int {
    case notLoad
    case loading
    case finished
    case failed
}

//enum OperationError: Error {
//    case failure(String)
//    case alreadyExistFavoriteAnime
//}

enum FavoriteEnum {
    case anime(entity: AnimeDetailEntity)
    case character(entity: AnimeCharacterEntity)
}

enum FetchFavoriteEnum {
    case anime
    case character
}

class BaseViewModel {
    internal let bag: DisposeBag = DisposeBag()
    
    let api = APIManager.shared
    let tokenHelper = TokenHelper()
    
    var loadingState = BehaviorRelay<StateLoading>(value: .notLoad)
    var loadingState2 = BehaviorRelay<StateLoading>(value: .notLoad)
    
    var toggle = BehaviorRelay<Bool>(value: false)
    var toggle2 = BehaviorRelay<Bool>(value: false)
    
//    typealias OperationCompletion = Result<String, OperationError>
    
    func storeToken(with token: String) {
        let tokenData = token.data(using: .utf8)
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "access_token",
        ]
        
        let attributes: [CFString: Any] = [
            kSecValueData: tokenData!,
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecSuccess {
            print("Token updated in Keychain")
        } else if status == errSecItemNotFound {
            // If the item doesn't exist, add it
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus == errSecSuccess {
                print("Token saved to Keychain")
            } else {
                print("Failed to save token to Keychain")
            }
        } else {
            print("Failed to update token in Keychain")
        }
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}

