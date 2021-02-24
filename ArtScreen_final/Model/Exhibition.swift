//
//  Exhibition.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/3.
//

import Foundation

struct Exhibitions: Decodable {
    var exhibitions: [ExhibitionDetail]
}

struct ExhibitionDetail: Decodable {
    var exhibitionID: String
    var userID: Int
    var exhibitionName: String
    var information: String
    var path: String
    var privacy: Int
}
