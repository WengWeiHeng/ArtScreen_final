//
//  UserCoverViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/5.
//

import Foundation

enum CoverStyle: Int, CaseIterable {
    case style1
    case style2
    case style3
}

struct ProfileViewModel {
    private let user: User
    
//    var buttonTitle: String {
//        if user.isCurrentUser {
//            return "Edit"
//        } else {
//            return "Follow"
//        }
//    }
    
    var fullnameText: String {
        return user.fullname
    }
    
    var usernameText: String {
        return "@" + user.username
    }
    
    init(user: User) {
        self.user = user
    }
}
