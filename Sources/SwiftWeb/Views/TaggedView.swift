//
//  TaggedView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

protocol TypeErasedTaggedView {
    var tag: Any? { get }
}

struct TaggedView<Body>: View, TypeErasedTaggedView where Body: View {
    let tag: Any?
    let body: Body
}

public extension View {
    func tag<V>(_ tag: V) -> some View where V: Hashable {
        TaggedView(tag: tag, body: self)
    }
}
