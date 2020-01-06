//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public extension View {
    func background<Background>(_ background: Background) -> some View where Background: View {
        guard let backgroundColor = background as? Color,
            case .div(let subNodes, let style) = html else {
            fatalError("not supported")
        }
        
        var newStyle = style
        newStyle[.backgroundColor] = .color(backgroundColor)

        return ModifiedView(newHTML: .div(subNodes: subNodes, style: newStyle))
    }
}
