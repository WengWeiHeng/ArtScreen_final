//
//  UserService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/18.
//

import Foundation

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void) {
        userDefault = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        if userDefault != nil {
            guard let id = userDefault["id"] as? String else { return }
            let user = User(id: id, dictionary: userDefault)
            completion(user)
        }
    }
}


