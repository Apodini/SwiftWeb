//
//  TupleView.swift
//  
//
//  Created by Quirin Schweigert on 11.01.20.
//

import Foundation

public protocol TypeErasedTupleView {
    func map<T>(_ transform: (TypeErasedView) -> T) -> [T]
    func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T]
}

public struct TupleView<T>: View, TypeErasedTupleView {
    public typealias Body = Never
    
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
    
    public var html: HTMLNode {
        return .div(subNodes: map(\.html), style: [:])
    }
    
    public func map<T>(_ transform: (TypeErasedView) -> T) -> [T] {
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
    
    public func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T] {
        return self.map {
            $0[keyPath: keyPath]
        }
    }
}

public extension View {
    static func buildSubnodes<Content>(fromView view: Content) -> [HTMLNode] where Content: View {
        if let tupleViewBody = view as? TypeErasedTupleView {
            return tupleViewBody.map(\.html)
        } else {
            return [view.html]
        }
    }
    
    static func buildSubnodes<Content>(fromView view: Content, inLayoutAxis layoutAxis: LayoutAxis) -> [HTMLNode] where Content: View {
        if let tupleViewBody = view as? TypeErasedTupleView {
            return tupleViewBody.map {
                $0.html(inLayoutAxis: layoutAxis)
            }
        } else {
            return [view.html(inLayoutAxis: layoutAxis)]
        }
    }
}
