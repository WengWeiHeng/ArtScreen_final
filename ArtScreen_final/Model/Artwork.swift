//
//  Artwork.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/27.
//

import Foundation

struct Artworks: Decodable {
    var artworks: [ArtworkDetail]
}

struct ArtworkDetail: Decodable {
    var artworkID: String
    var userID: Int
    var artworkName: String
    var information: String
    var path: URL
    var locationLat: Double
    var locationLng: Double
}
