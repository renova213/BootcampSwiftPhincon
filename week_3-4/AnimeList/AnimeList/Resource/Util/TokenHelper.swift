import Foundation
import Security

struct TokenKey{
    static let tokenAccess = "access_token"
}

class TokenHelper {
    static let shared = TokenHelper()
    
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
        
        if status == errSecItemNotFound {
            var newQuery = query
            newQuery[kSecValueData] = tokenData
            SecItemAdd(newQuery as CFDictionary, nil)
        }
    }
    
    func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return ""
        }
    }
    
    func deleteToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
