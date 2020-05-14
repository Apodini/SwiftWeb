//
//  TaggedView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

public protocol TypeErasedTaggedView {
    var tag: Any? { get }
}

public struct TaggedView<Body>: View, TypeErasedTaggedView where Body: View {
    public let tag: Any?
    public let body: Body
}

public extension View {
    func tag<V>(_ tag: V) -> some View where V : Hashable {
        return TaggedView(tag: tag, body: self)
    }
}
