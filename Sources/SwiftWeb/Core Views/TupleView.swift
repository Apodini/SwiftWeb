//
//  TupleView.swift
//  
//
//  Created by Quirin Schweigert on 11.01.20.
//

import Foundation

public protocol TypeErasedTupleView {
    func mapToHTMLNodes() -> [HTMLNode]
}

public struct TupleView<T>: View, TypeErasedTupleView {
    public typealias Body = Never
    
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
    
    public var html: HTMLNode {
        return .div(subNodes: mapToHTMLNodes(), style: [:])
    }
    
    public func mapToHTMLNodes() -> [HTMLNode] {
        let mirror = Mirror(reflecting: value)
        var mappedValues: [HTMLNode] = []
        
        for child in mirror.children {
            guard let view = child.value as? TypeErasedView else {
                fatalError("TupleView must contain a tuple of Views")
            }

            mappedValues.append(view.html)
        }
        
        return mappedValues
    }
}

public extension View {
    static func buildSubnodes<Content>(fromView view: Content) -> [HTMLNode] where Content: View {
        if let tupleViewBody = view as? TypeErasedTupleView {
            return tupleViewBody.mapToHTMLNodes()
        } else {
            return [view.html]
        }
    }
}
