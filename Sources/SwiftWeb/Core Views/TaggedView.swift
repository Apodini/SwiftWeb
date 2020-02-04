//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

public protocol TaggedViewProtocol {
    var tag: Any? { get }
}

public struct TaggedView<Body>: View, TaggedViewProtocol where Body: View {
    public let tag: Any?
    public let body: Body
    
    public init(tag: Any, body: Body) {
        self.tag = tag
        self.body = body
    }
}

public extension View {
    func tag<V>(_ tag: V) -> some View where V : Hashable {
        return TaggedView(tag: tag, body: self)
    }
}
