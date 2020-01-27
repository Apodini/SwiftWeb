//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Font {
    let size: Double
    let weight: Weight
    
    public static func system(size: Double, weight: Weight = .regular) -> Font {
        return Font(size: size, weight: weight)
    }
    
    public enum Weight: Int {
        case thin = 150
        case regular = 250
        case medium = 400
        case semibold = 500
        case bold = 600
    }
}
