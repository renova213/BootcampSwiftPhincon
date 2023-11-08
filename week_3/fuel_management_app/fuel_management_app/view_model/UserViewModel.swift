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
        saveUserToUserDefaults(userData: loginResponse.user!)
    }
    
    func fetchUserByUsername() {
        if let username = user?.username {
            let endpoint = Endpoint.getUserByUsername(param: username)
            
            APIManager.shared.fetchRequest(endpoint: endpoint, expecting: UserEntity.self) { result in
                switch result {
                case .success(let userData):
                    self.user = userData
                    self.saveUserToUserDefaults(userData: userData)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateUser(email: String, phone: String, address: String, completion: @escaping(Result<UserEntity, APIError>)-> Void ) {
        let endpoint = Endpoint.updateUser(param: UserEntity(id: user!.id, username: user!.username, email: email, address: address, urlImage: user!.urlImage, phone: phone))
        
        APIManager.shared.fetchRequest(endpoint: endpoint, expecting: UserEntity.self) { result in
            completion(result)
        }
    }
    
    func getUser() -> UserEntity{
        getUserFromUserDefaults()
        return user ?? UserEntity(id: "0", username: "-", email: "-", address: "-", urlImage: "-", phone: "-")
    }
    
    func saveUserToUserDefaults(userData: UserEntity) {
        user = userData
        if let encodedData = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encodedData, forKey: "user")
        }
    }
    
    func getUserFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "user"),
           let decodedUser = try? JSONDecoder().decode(UserEntity.self, from: savedData) {
            self.user = decodedUser
        }
    }
}
