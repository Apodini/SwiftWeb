//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct Color: View {
    static var clear: Self {
        return Self()
    }
    
    public let body: View? = nil
    
    let color: (red: Int, green: Int, blue: Int, alpha: Double)
    let clear: Bool
    
    var cssString: String {
        if clear {
            return "transparent"
        }
        
        return "rgba(\(color.red), \(color.green), \(color.blue), \(color.alpha))"
    }
    
    public var html: HTMLNode {
        .div(style: [
            .backgroundColor : .color(self),
            .alignSelf: .stretch,
            .flexGrow: .one
        ])
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        color = (red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), alpha: alpha)
        clear = false
    }
    
    public init(red: Double, green: Double, blue: Double) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public init(white: Double) {
        self.init(red: white, green: white, blue: white)
    }
    
    init() {
        color = (red: 0, green: 0, blue: 0, alpha: 0)
        clear = true
    }
}

public extension View {
    func foregroundColor(_ color: Color?) -> View {
        guard case .div(let subNodes, let style) = html else {
            return self
        }
        
        var newStyle = style
        
        let newColor: Color = color ?? .clear
        
        newStyle[.color] = .color(newColor)

        return ModifiedView(newHTML: .div(subNodes: subNodes, style: newStyle))
    }
}
