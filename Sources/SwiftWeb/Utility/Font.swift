//
//  Font.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Font {
    let size: Double
    let weight: Weight
    let design: Design
    
    public static func system(size: Double,
                              weight: Weight = .regular,
                              design: Design = .default) -> Font {
        return Font(size: size, weight: weight, design: design)
    }
    
    public enum Weight: Int {
        case thin = 150
        case regular = 250
        case medium = 400
        case semibold = 500
        case bold = 600
    }
    
    public enum Design : Hashable {
        case `default`
        case rounded
    }
}
