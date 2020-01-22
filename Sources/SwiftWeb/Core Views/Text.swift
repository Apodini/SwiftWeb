//
//  Text.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct Text: View {
    public typealias Body = Never
    
    public let html: HTMLNode
    
    let text: String
    
    public init(_ text: String) {
        self.text = text
        self.html =
            .div(style: [.justifyContent: .center, .alignItems: .center]) {
                .div(style: [.flexGrow: .zero]) {
                    .raw(text)
                }
            }
    }
    
    init(newHTML: HTMLNode, text: String) {
        html = newHTML
        self.text = text
    }
    
    public func font(_ font: Font) -> Text {
        guard case .div(let subNodes, let style) = html else {
            return self
        }
        
        var newStyle = style
        newStyle[.fontSize] = .px(font.size)
        newStyle[.fontWeight] = .int(font.weight.rawValue)

        return Text(newHTML: .div(subNodes: subNodes, style: newStyle), text: text)
    }
}
