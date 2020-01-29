//
//  TupleView.swift
//  
//
//  Created by Quirin Schweigert on 11.01.20.
//

import Foundation

public protocol TypeErasedTupleView: GrowingAxesModifying, CustomMappable {
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
    
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> {
        self.map(\.growingLayoutAxes).reduce([]) { accumulator, growthAxes in
            accumulator.union(growthAxes)
        }
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

//public extension View {
//    static func buildSubnodes<Content>(fromView view: Content) -> [HTMLNode] where Content: View {
//        return view.map { $0.html }
//    }
//
//    static func buildSubnodes<Content>(fromView view: Content, inLayoutAxis layoutAxis: LayoutAxis) -> [HTMLNode] where Content: View {
//        return view.map { $0.html(inLayoutAxis: layoutAxis) }
//    }
//}
