//
//  Color.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

/// An environment-dependent color.
public struct Color: View, GrowingAxesModifying {
    public typealias Body = Never
    
    public static var clear: Self {
        Self()
    }
    
    public static let red = Color(red: 1.0, green: 0.0, blue: 0.0)
    public static let green = Color(red: 0.0, green: 1.0, blue: 0.0)
    public static let blue = Color(red: 0.0, green: 0.0, blue: 1.0)
    public static let systemBlue = Color(red: 0.01, green: 0.48, blue: 1.00)
    public static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    public static let white = Color(red: 1.0, green: 1.0, blue: 1.0)
    public static let black = Color(red: 0.0, green: 0.0, blue: 0.0)
    
    let color: (red: Int, green: Int, blue: Int, opacity: Double)
    let clear: Bool
    
    var cssString: String {
        if clear {
            return "transparent"
        }
        
        return "rgba(\(color.red), \(color.green), \(color.blue), \(color.opacity))"
    }
    
    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis> {
            [.vertical, .horizontal]
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .div(style: [
            .backgroundColor: .color(self),
            .alignSelf: .stretch,
            .flexGrow: .one
        ])
    }

    /// Initializes a color with the supplied values for the red, green and blue components as well as the opacity.
    public init(red: Double, green: Double, blue: Double, opacity: Double) {
        color = (red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), opacity: opacity)
        clear = false
    }
    
    /// Initializes a color with the supplied values for the red, green and blue components.
    public init(red: Double, green: Double, blue: Double) {
        self.init(red: red, green: green, blue: blue, opacity: 1.0)
    }
    
    /// Initialized a grayscale `Color` with the supplied brightness.
    public init(white: Double) {
        self.init(red: white, green: white, blue: white)
    }
    
    init() {
        color = (red: 0, green: 0, blue: 0, opacity: 0)
        clear = true
    }
    
    init(red: Int, green: Int, blue: Int, opacity: Double) {
        color = (red: red, green: green, blue: blue, opacity: opacity)
        clear = false
    }
    
    /// Returns this color with the supplied opacity value.
    public func opacity(_ opacity: Double) -> Color {
        Color(red: color.red, green: color.green, blue: color.blue, opacity: opacity)
    }
}

public extension View {
    func foregroundColor(_ color: Color?) -> some View {
        let newColor: Color = color ?? .clear
        
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier { html in
            html.withStyle(key: .color, value: .color(newColor))
        })
    }
}
