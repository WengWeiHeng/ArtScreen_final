//
//  User.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import Foundation

struct User {
    let uid: String
    let email: String
    let fullname: String
    let username: String
    var profileImageUrl: URL?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["userID"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String{
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
