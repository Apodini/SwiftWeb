//
//  AnyView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

public struct AnyView: View, CustomMappable {
    public typealias Body = Never
    let containedView: TypeErasedView
    
    public var html: HTMLNode {
        .raw("not implemented")
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        containedView.html(forHTMLOfSubnodes: htmlOfSubnodes)
    }
    
    init<Content>(content: Content) where Content: View {
        containedView = content
    }
    
    init(content: TypeErasedView) {
        containedView = content
    }
    
    public func customMap<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        return [transform(containedView)]
    }
}

public extension TypeErasedView {
    func anyView() -> AnyView {
        return AnyView(content: self)
    }
}
