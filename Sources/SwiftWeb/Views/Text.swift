//
//  Text.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct Text: View {
    public typealias Body = Never

    let text: String
    public let html: HTMLNode = .raw("deprecated")
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .div(style: [.justifyContent: .center, .alignItems: .center]) {
            .div(style: [.flexGrow: .zero]) {
                .raw(text)
            }
        }
    }
}

extension View {
    public func font(_ font: Font) -> some View {
        var newHTML = html
            .withStyle(key: .fontSize, value: .px(font.size))
            .withStyle(key: .fontWeight, value: .int(font.weight.rawValue))
        
        if font.design == .rounded {
            newHTML = newHTML.withStyle(
                key: .fontFamily,
                value: .raw("sf-pro-rounded-bold")
            )
        }
        
        return ModifiedView(body: self, newHTML: newHTML)
    }
}
