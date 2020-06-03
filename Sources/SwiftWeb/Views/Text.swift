//
//  Text.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

/// A view that displays one or more lines of read-only text.
public struct Text: View {
    public typealias Body = Never

    let text: String
    let isBold: Bool
    public let html: HTMLNode = .raw("deprecated")
    
    /// Creates a text view that displays a string literal without localization.
    public init(_ text: String) {
        self.text = text
        isBold = false
    }
    
    init(_ text: String, isBold: Bool) {
        self.text = text
        self.isBold = isBold
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        var html: HTMLNode =
            .div(style: [.justifyContent: .center, .alignItems: .center]) {
                .div(style: [.flexGrow: .zero]) {
                    .raw(text)
                }
            }
        
        if isBold {
            html = html.withStyle(key: .fontWeight, value: .int(Font.Weight.bold.rawValue))
        }
        
        return html
    }
}

public extension Text {
    /// Applies a bold font weight to the text.
    func bold() -> Text {
        Text(text, isBold: true)
    }
}
