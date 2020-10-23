//
//  ToolBarViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

enum ToolBarOption: Int, CaseIterable {
    case paint
    case font
    case typeface
    case color
    case photo
    case template
    case delete
    
    var description: String {
        switch self {
        case .paint: return "Paint"
        case .font: return "Font"
        case .typeface: return "Typeface"
        case .color: return "Color"
        case .photo: return "Photo"
        case .template: return "Template"
        case .delete: return "Delete"
        }
    }
    
    var iconName: String {
        switch self {
        case .paint: return "paint"
        case .font: return "font"
        case .typeface: return "typeface"
        case .color: return "color"
        case .photo: return "photo"
        case .template: return "template"
        case .delete: return "delete"
        }
    }
}

struct ToolBarState {
    
}

