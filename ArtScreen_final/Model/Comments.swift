//
//  Comment.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/16.
//

import Foundation

struct Comments: Decodable {
    var comments: [CommentDetail]
}

struct CommentDetail: Decodable {
    var commentID: String
    var userID: Int
    var artworkID: String
    var message: String
    var time: String
    
//    Date(timeIntervalSince1970: timestamp)
}
