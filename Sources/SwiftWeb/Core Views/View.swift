//
//  View.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public protocol TypeErasedView {
    var html: HTMLNode { get }
}

public protocol View: TypeErasedView {
    associatedtype Body: View
    
    var body: Body { get }
    
    var html: HTMLNode { get }
}

public extension View {
    func cornerRadius(_ radius: Double) -> ModifiedView {
        return ModifiedView(newHTML: html.withAddedStyle(key: .borderRadius, value: .px(radius)) ?? html)
    }
    
    func shadow(color: Color, radius: Double, x: Double, y: Double) -> ModifiedView {
        return ModifiedView(newHTML:
            html.withAddedStyle(key: .boxShadow,
                                value: .shadow(offsetX: x,
                                               offsetY: y,
                                               radius: radius,
                                               color: color)) ?? html
        )
    }
}

public extension View {
    var body: some View {
        return EmptyView()
    }
}

public extension View {
    var html: HTMLNode {
        body.html
    }
}

extension Never: View {
    public var body: Never { fatalError("Never Type has no body") }
}

public struct EmptyView: View {
    public typealias Body = Never
}

public extension View where Body == Never {
    var body: Never { fatalError("\(type(of: self)) has no body") }
}
