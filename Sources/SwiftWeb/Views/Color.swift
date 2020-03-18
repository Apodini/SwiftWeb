//
//  Color.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct Color: View, GrowingAxesModifying {
    public typealias Body = Never
    
    public static var clear: Self {
        return Self()
    }
    
    public static let red = Color(red: 1.0, green: 0.0, blue: 0.0)
    public static let green = Color(red: 0.0, green: 1.0, blue: 0.0)
    public static let blue = Color(red: 0.0, green: 0.0, blue: 1.0)
    public static let systemBlue = Color(red:0.01, green: 0.48, blue: 1.00)
    public static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    let color: (red: Int, green: Int, blue: Int, alpha: Double)
    let clear: Bool
    
    var cssString: String {
        if clear {
            return "transparent"
        }
        
        return "rgba(\(color.red), \(color.green), \(color.blue), \(color.alpha))"
    }
    
    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis> {
            [.vertical, .horizontal]
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
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
    
    init(red: Int, green: Int, blue: Int, alpha: Double) {
        color = (red: red, green: green, blue: blue, alpha: alpha)
        clear = false
    }
    
    public func opacity(_ alpha: Double) -> Color {
        return Color(red: color.red, green: color.green, blue: color.blue, alpha: alpha)
    }
}

public extension View {
    func foregroundColor(_ color: Color?) -> some View {
        let newColor: Color = color ?? .clear
        
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            html.withStyle(key: .color, value: .color(newColor))
        })
    }
}
