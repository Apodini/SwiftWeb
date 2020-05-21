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
    /// The `Never` type indicates that this view doesn't define its subviews via the `body` property.
    public typealias Body = Never
    let containedView: TypeErasedView
    
    /// The implementation of this method delegates to the `content` view.
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        containedView.html(forHTMLOfSubnodes: htmlOfSubnodes)
    }
    
    /// Instantiates an `AnyView` by wrapping `content`.
    public init<Content>(content: Content) where Content: View {
        containedView = content
    }
    
    /// Instantiates an `AnyView` by wrapping `content`.
    public init(content: TypeErasedView) {
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
