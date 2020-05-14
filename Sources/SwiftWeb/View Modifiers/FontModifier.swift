//
//  FontModifier.swift
//  
//
//  Created by Quirin Schweigert on 10.03.20.
//

import Foundation

struct FontModifier<Content>: ViewModifier where Content: View {
    typealias Body = Content
    
    let font: Font
    
    func html(forHTMLOfContent htmlOfContent: HTMLNode) -> HTMLNode {
        var newHTML = htmlOfContent
            .withStyle(key: .fontSize, value: .px(font.size))
            .withStyle(key: .fontWeight, value: .int(font.weight.rawValue))
        
        if font.design == .rounded {
            newHTML = newHTML.withStyle(
                key: .fontFamily,
                value: .raw("sf-pro-rounded-bold")
            )
        }
        
        return newHTML
    }
}

extension View {
    public func font(_ font: Font) -> some View {
        return ModifiedContent(content: self, modifier: FontModifier(font: font))
    }
}
