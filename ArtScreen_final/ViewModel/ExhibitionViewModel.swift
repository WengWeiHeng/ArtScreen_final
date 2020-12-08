//
//  ExhibitionViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/8.
//

import UIKit

struct ExhibitionViewModel {
    let exhibition: ExhibitionDetail
    let user: User
    
    var profileImageUrl: URL? {
        return exhibition.user.profileImageUrl
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    init(exhibition: Exhibition) {
        self.exhibition = exhibition
        self.user = exhibition.user
    }
}
