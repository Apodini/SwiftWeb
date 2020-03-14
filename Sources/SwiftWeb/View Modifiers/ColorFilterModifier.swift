//
//  ColorFilterModifier.swift
//  
//
//  Created by Quirin Schweigert on 10.03.20.
//

import Foundation

struct ColorFilterModifier<Content>: ViewModifier where Content: View {
    typealias Body = Content
    
    let cssFilterString: String
    
    func html(forHTMLOfContent htmlOfContent: HTMLNode) -> HTMLNode {
        htmlOfContent.withStyle(key: .filter, value: .raw(cssFilterString))
    }
}

extension View {
    func systemBlueFilter() -> some View {
        let cssFilter = "contrast(0%) brightness(0%) invert(39%) sepia(81%) saturate(4741%) hue-rotate(202deg) brightness(103%) contrast(101%)"
        
        return ModifiedContent(
            content: self,
            modifier: ColorFilterModifier(cssFilterString: cssFilter)
        )
    }
    
    func systemGrayFilter() -> some View {
        let cssFilter = "contrast(0%) brightness(0%) invert(60%) sepia(0%) saturate(0%) hue-rotate(111deg) brightness(98%) contrast(96%)"
        
        return ModifiedContent(
            content: self,
            modifier: ColorFilterModifier(cssFilterString: cssFilter)
        )
    }
}
