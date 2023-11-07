//
//  UserViewModel.swift
//  fuel_management_app
//
//  Created by Phincon on 06/11/23.
//

import Foundation

class UserViewModel {
    private var user: UserEntity?
    
    static let shared = UserViewModel()
    
    func setUserFromLoginResponse(loginResponse: LoginResponse) {
        
        self.user = loginResponse.user
        saveUserToUserDefaults()
    }
    
    func fetchUser() {
        let endpoint = Endpoint.getUser
        
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: UserEntity.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    self.user = userData
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getUser() -> UserEntity{
        getUserFromUserDefaults()
        return user ?? UserEntity(id: "0", username: "-", email: "-", address: "-", urlImage: "-", phone: "-")
    }
    
    private func saveUserToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedData, forKey: "user")
        }
    }
    
    private func getUserFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "user"),
           let decodedUser = try? JSONDecoder().decode(UserEntity.self, from: savedData) {
            self.user = decodedUser
        }
    }
}
