//
//  FeatureToolBarViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import Foundation

//MARK: - FeatureToolBarOption
enum FeatureToolBarOption : Int,CaseIterable {
    case pen
    case lasso
    case delete

    var description : String {
        switch self {
        case .pen: return "Pen"
        case .lasso: return "Lasso"
        case .delete: return "Delete"
        
        }
    }
    var iconName : String {
        switch self {
        case .pen: return "pen"
        case .lasso: return "lasso"
        case .delete: return "delete"
        
        }
    }
}

//MARK: - PenToolBarOption
enum PenToolBarOption: Int, CaseIterable {
    case close
    case joint
    case crop
    case clear
    
    var description: String {
        switch self {
        case .close: return "Close"
        case .joint: return "Joint"
        case .crop: return "Crop"
        case .clear: return "Clear"
        }
    }
    
    var iconName : String {
        switch self {
        case .close: return "close"
        case .joint: return "joint"
        case .crop: return "crop"
        case .clear: return "clear"
        
        }
    }
}

//MARK: - LassoToolBaroption
enum LassoToolBarOption: Int, CaseIterable {
    case close
    case undo
    case joint
    case crop
    case clear
    
    var description: String {
        switch self {
        case .close: return "Close"
        case .undo: return "Undo"
        case .joint: return "Joint"
        case .crop: return "Crop"
        case .clear: return "Clear"
        }
    }
    
    var iconName : String {
        switch self {
        case .close: return "close"
        case .undo: return "undo"
        case .joint: return "joint"
        case .crop: return "crop"
        case .clear: return "clear"
        
        }
    }
}

//MARK: - AnimateToolBarOption
enum AnimateToolBarOption : Int,CaseIterable {
    case path
    case rotate
    case scale
    case opacity
    case emitter
    
    var description : String {
        switch self {
        case .path: return "Path"
        case .rotate: return "Rotate"
        case .scale: return "Scale"
        case .opacity: return "Opacity"
        case .emitter: return "Emitter"
        }
    }
    var iconName : String {
        switch self {
        case .path: return "path"
        case .rotate: return "rotate"
        case .scale: return "scale"
        case .opacity: return "opacity"
        case .emitter: return "emitter"
        }
    }
}

//MARK: - DefaultToolBarOption
enum DefaultToolBarOption : Int,CaseIterable {
    case Paint
    case Font
    case Style
    case Color
    case Delete
    var description : String {
        switch self {
        case .Paint: return "Paint"
        case .Font: return "Font"
        case .Style: return "Style"
        case .Color: return "Color"
        case .Delete: return "Delete"
        }
    }
    var iconName : String {
        switch self {
        case .Paint: return "paint"
        case .Font: return "font"
        case .Style: return "style"
        case .Color: return "color"
        case .Delete: return "delete"
        }
    }
}


