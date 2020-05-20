//
//  AnyView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

/**
 A type-erased `View`.
 
 An AnyView allows changing the type of view used in a given view hierarchy.
 */
public struct AnyView: View, CustomMappable {
    public typealias Body = Never
    let containedView: TypeErasedView
    
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
