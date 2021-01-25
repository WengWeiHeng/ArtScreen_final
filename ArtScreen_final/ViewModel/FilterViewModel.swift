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
    case accounts
    case artworks
    case exhibitions
    
    var description: String {
        switch self {
        case .accounts: return "Accounts"
        case .artworks: return "Artworks"
        case .exhibitions: return "Exhibitions"
        }
    }
}

struct FilterViewModel {
    
}

