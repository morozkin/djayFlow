//
//  SkillLevel.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

enum SkillLevel {
    case newbie
    case amateur
    case pro
    
    var description: String {
        switch self {
        case .newbie:
            "I’m new to DJing"
        case .amateur:
            "I’ve used DJ apps before"
        case .pro:
            "I’m a professional DJ"
        }
    }
}
