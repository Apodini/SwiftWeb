//
//  AnyView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

public struct AnyView: View {
    public typealias Body = Never
    
    public var html: HTMLNode
    
    init(html: HTMLNode) {
        self.html = html
    }
    
    init<Content>(content: Content) where Content: View {
        self.init(html: content.html)
    }
}

public extension TypeErasedView {
    func anyView() -> AnyView {
        return AnyView(html: html)
    }
}
