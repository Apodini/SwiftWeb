//
//  ModifiedContent.swift
//  
//
//  Created by Quirin Schweigert on 10.03.20.
//

import Foundation

struct ModifiedContent<Content, Modifier>: View
where Modifier: ViewModifier, Modifier.Content == Content {
    let content: Content
    let modifier: Modifier
    
    var body: some View {
        modifier.body(content: content)
    }
    
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        modifier.html(forHTMLOfContent: htmlOfSubnodes.joined())
    }
}

/// A modifier that you apply to a view or another view modifier, producing a different version of the original value.
public protocol ViewModifier {
    /// The type of view representing the body.
    associatedtype Body: View
    
    /// The content view type.
    associatedtype Content: View
    
    /// Gets the current body of the caller.
    func body(content: Self.Content) -> Self.Body
    
    /// Specifies the transformation of HTML as implemented by this `ViewModifier`
    func html(forHTMLOfContent: HTMLNode) -> HTMLNode
}

public extension ViewModifier {
    func html(forHTMLOfContent htmlOfContent: HTMLNode) -> HTMLNode { // Shouldn't we somewhere delegate to body(content:).html(for... ?
        htmlOfContent
    }
}

public extension ViewModifier where Body == Content {
    /// Returns `content` as `body`.
    func body(content: Self.Content) -> Self.Body {
        content
    }
}

struct HTMLTransformingViewModifier<Content>: ViewModifier where Content: View {
    let transform: (HTMLNode) -> HTMLNode
    typealias Body = Content

    init(transform: @escaping (HTMLNode) -> HTMLNode) {
        self.transform = transform
    }
    
    func html(forHTMLOfContent htmlOfContent: HTMLNode) -> HTMLNode {
        transform(htmlOfContent)
    }
}
