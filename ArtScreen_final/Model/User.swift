//
//  User.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import Foundation

struct Users: Decodable {
    var users: [User]
}

struct User: Decodable {
    let id: Int
    let username: String
    let email: String
    let fullname: String
    var ava: URL?
    
//    var user: NSDictionary?
    
    init(id: Int, dictionary: NSDictionary) {
        self.id = id
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""

        if let profileImageUrlString = dictionary["ava"] as? String{
            guard let url = URL(string: profileImageUrlString) else { return }
            self.ava = url
        }
    }
}
