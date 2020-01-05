//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

struct ModifiedView: View {
    var body: View? = nil
    var html: HTMLNode
    
    init(newHTML: HTMLNode) {
        html = newHTML
    }
}

public extension View {
    func foregroundColor(_ color: Color?) -> View {
        guard case .div(let subNodes, let style) = html else {
            return self
        }
        
        var newStyle = style
        newStyle[.color] = color?.cssValue ?? Color.clearCSSValue

        return ModifiedView(newHTML: .div(subNodes: subNodes, style: newStyle))
    }
}
