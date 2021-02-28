//
//  MenuViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import Foundation

enum MenuOptions: Int, CaseIterable, CustomStringConvertible{
    case notification
    case placeMap
    case arCamere
//    case setting
    case instructions
    case logOut
    
    var description: String{
        switch self {
        case .notification:
            return "Notification"
        case .placeMap:
            return "Art Map"
        case .arCamere:
            return "AR Camera"
//        case .setting:
//            return "Setting"
        case .instructions:
            return "Instructions"
        case .logOut:
            return "Log Out"
        }
    }
    
    var iconImage: String {
        switch self {
        case .notification:
            return "notification"
        case .placeMap:
            return "placeMap"
        case .arCamere:
            return "arCamera"
//        case .setting:
//            return "setting"
        case .instructions:
            return "instructions"
        case .logOut:
            return "logOut"
        }
    }
}
