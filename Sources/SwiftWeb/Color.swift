//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct Color: View {
    static let clearCSSValue = "transparent"
    
    public var body: View? = nil
    
    let color: (red: Int, green: Int, blue: Int, alpha: Double)
    
    var cssValue: String {
        "rgba(\(color.red), \(color.green), \(color.blue), \(color.alpha))"
    }
    
    public var html: HTMLNode {
        .div(subNodes: [], style: [
            .backgroundColor : cssValue,
        ])
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        color = (red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), alpha: alpha)
    }
    
    public init(red: Double, green: Double, blue: Double) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public init(white: Double) {
        self.init(red: white, green: white, blue: white)
    }
}
