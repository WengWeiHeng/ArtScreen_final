//
//  User.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import Foundation

struct User {
    let id: String
    let username: String
    let email: String
    let fullname: String
    var profileImageUrl: URL?
    
    var user: NSDictionary?
    
    init(id: String, dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["ava"] as? String{
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
