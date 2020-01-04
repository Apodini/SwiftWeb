//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct Color: View {
    public var body: View? = nil
    
    let color: (red: Int, green: Int, blue: Int, alpha: Double)
    
    public var html: HTMLNode {
        .div(subNodes: [], style: [
            .backgroundColor : "rgba(\(color.red), \(color.green), \(color.blue), \(color.alpha))",
        ])
    }
    
    public init(red: Int, green: Int, blue: Int, alpha: Double) {
        color = (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public init(red: Int, green: Int, blue: Int) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public init(white: Double) {
        self.init(red: Int(white * 255), green: Int(white * 255), blue: Int(white * 255))
    }
}
