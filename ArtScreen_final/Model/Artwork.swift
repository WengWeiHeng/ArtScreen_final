//
//  Artwork.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/27.
//

import Foundation

struct Artwork {
    let artworkID: String
    let userID: String
    let artworkName: String
    let information: String
    var artworkImageURL: URL!
    let locationLat: Double
    let locationLng: Double

    init(dictionary: NSDictionary) {
        self.artworkID = dictionary["artworkID"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.artworkName = dictionary["artworkName"] as? String ?? ""
        self.information = dictionary["information"] as? String ?? ""
        self.locationLat = dictionary["locationLat"] as? Double ?? 0
        self.locationLng = dictionary["locationLng"] as? Double ?? 0
        
        if let artworkImageURLString = dictionary["path"] as? String{
            guard let url = URL(string: artworkImageURLString) else { return }
            self.artworkImageURL = url
        }
    }
}
