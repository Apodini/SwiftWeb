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
        case thin = 100
        case regular = 200
        case medium = 400
    }
}
