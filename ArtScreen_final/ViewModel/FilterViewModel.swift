//
//  FilterViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

enum FilterOptions: Int, CaseIterable {
    case exhibitions
    case artworks
    
    var description: String {
        switch self {
        case .exhibitions: return "EXHIBITION"
        case .artworks: return "ARTWORK"
        }
    }
}

enum SearchOptions: Int, CaseIterable {
    case all
    case artist
    case artwork
    case exhibition
    case place
    
    var description: String {
        switch self {
        case .all: return "All"
        case .artist: return "Artist"
        case .artwork: return "Artwork"
        case .exhibition: return "Exhibition"
        case .place: return "Place"
        }
    }
}

struct FilterViewModel {
    
}
