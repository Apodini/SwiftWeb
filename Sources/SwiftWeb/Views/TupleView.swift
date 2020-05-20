//
//  TupleView.swift
//  
//
//  Created by Quirin Schweigert on 11.01.20.
//

import Foundation

protocol TypeErasedTupleView: CustomMappable {
    func map<T>(_ transform: (TypeErasedView) -> T) -> [T]
    func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T]
}

/// A View created from a swift tuple of View values.
public struct TupleView<T>: View, TypeErasedTupleView {
    public typealias Body = Never
    
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
    
    // TODO: this doesn't have any effect since TupleViews are not included in the ViewTree
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes.joined()
    }
    
    public func customMap<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        let mirror = Mirror(reflecting: value)
        return mirror.children
            .map { child in
                guard let view = child.value as? TypeErasedView else {
                    fatalError("TupleView must contain a tuple of Views")
                }
                
                return view
            }
            .map(transform)
    }
}
