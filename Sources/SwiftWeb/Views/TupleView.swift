//
//  TupleView.swift
//  
//
//  Created by Quirin Schweigert on 11.01.20.
//

import Foundation

public protocol TypeErasedTupleView: CustomMappable {
    func map<T>(_ transform: (TypeErasedView) -> T) -> [T]
    func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T]
}

public struct TupleView<T>: View, TypeErasedTupleView {
    public typealias Body = Never
    
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
    
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
