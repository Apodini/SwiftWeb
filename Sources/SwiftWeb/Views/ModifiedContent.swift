//
//  ModifiedContent.swift
//  
//
//  Created by Quirin Schweigert on 10.03.20.
//

import Foundation

struct ModifiedContent<Content, Modifier>: View
where Content: View, Modifier: ViewModifier, Modifier.Content == Content {
    let content: Content
    let modifier: Modifier
    
    var body: some View {
        modifier.body(content: content)
    }
    
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        modifier.html(forHTMLOfContent: content.html(forHTMLOfSubnodes: htmlOfSubnodes))
    }
}

public protocol ViewModifier {
    associatedtype Body: View
    associatedtype Content: View
    
    func body(content: Self.Content) -> Self.Body
    func html(forHTMLOfContent: HTMLNode) -> HTMLNode
}

public extension ViewModifier {
    func html(forHTMLOfContent htmlOfContent: HTMLNode) -> HTMLNode { // Shouldn't we somewhere delegate to body(content:).html(for... ?
        htmlOfContent
    }
}

public extension ViewModifier where Body == Content {
    func body(content: Self.Content) -> Self.Body {
        content
    }
}

// do we need this? Why?
public extension ViewModifier where Body == Never {
    func body(content: Self.Content) -> Self.Body {
        fatalError()
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
