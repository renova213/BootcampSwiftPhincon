import Foundation

class UserDefaultHelper {
    static let shared = UserDefaultHelper()
    
    func saveUserIDToUserDefaults(userID: String) {
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "user_id")
        defaults.synchronize()
    }
    
    func getUserIDFromUserDefaults() -> String? {
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "user_id")
        
        return userID
    }
    
    func deleteUserIDFromUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_id")
        defaults.synchronize()
    }
}
