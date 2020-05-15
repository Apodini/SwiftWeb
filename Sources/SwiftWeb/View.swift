//
//  View.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public protocol TypeErasedView {
    var layoutAxis: LayoutAxis { get }
    func html(forHTMLOfSubnodes: [HTMLNode]) -> HTMLNode
    
    func map<T>(_ transform: (TypeErasedView) -> T) -> [T]
    func mapBody<T>(_ transform: (TypeErasedView) -> T) -> [T]
    func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T]
    func deepMap<T>(_ transform: (TypeErasedView) -> T) -> [T]
}

public protocol View: TypeErasedView {
    associatedtype Body: View
    
    // The body property is used to delegate the generation of html for a
    // specific node to another view. It should be set for all view which
    // enclose other views in order to allow the layout system to propagate
    // properties properly through the tree.
    var body: Body { get }
}

// MARK: View body default implementation

public extension View {
    var layoutAxis: LayoutAxis {
        .vertical
    }
    
    var body: some View {
        return EmptyView()
    }
}

public extension View {
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes.joined()
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


// MARK: View modifiers

public extension View {
    func cornerRadius(_ radius: Double) -> some View {
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            html
                .withStyle(key: .borderRadius, value: .px(radius))
                .withStyle(key: .overflow, value: .hidden)
        })
    }
    
    func shadow(color: Color = Color(white: 0.0).opacity(0.20),
                radius: Double = 40.0,
                x: Double = 0.0,
                y: Double = 2.0
    ) -> some View {
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            html.withStyle(key: .boxShadow,
                           value: .shadow(offsetX: x,
                                          offsetY: y,
                                          radius: radius,
                                          color: color))
        })
    }
    
    func padding(_ edges: Edge.Set = .all, _ length: Double? = nil) -> some View {
        let length = length ?? 10.0
        
        let paddingPropertyMapping: [(cssKey: HTMLNode.CSSKey, edgeSet: Edge.Set)] = [
            (.paddingTop, .top),
            (.paddingLeft, .leading),
            (.paddingRight, .trailing),
            (.paddingBottom, .bottom),
        ]
        
        let paddingStyle = Dictionary(uniqueKeysWithValues: paddingPropertyMapping.compactMap({
            edges.contains($0.edgeSet) ? ($0.cssKey, HTMLNode.CSSValue.px(length)) : nil
        }))
        
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            .div(
                subNodes: [html
                    .withStyle(key: .flexGrow, value: .one)
                    .withStyle(key: .alignSelf, value: .stretch)],
                style: paddingStyle
            )
        })
    }
    
    func padding(_ length: Double? = nil) -> some View {
        padding(.all, length)
    }
    
    func border(_ color: Color, width: Double = 1) -> some View {
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            html.withStyle(key: .border,
                           value: .border(width: width, color: color))
        })
    }
}


// MARK: View description
    
public extension TypeErasedView {
    var debugDescription: String {
        String(describing: Self.self)
    }
}


// MARK: CustomMappable

public protocol CustomMappable {
    func customMap<T>(_ transform: (TypeErasedView) -> T) -> [T]
}

extension View {
    public func mapBody<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        guard type(of: Body.self) != type(of: Never.self) else {
            return []
        }
        
        if let customMappableBody = body as? CustomMappable {
            
            // This is where the recursion happens that makes composing TupleViews and ForEach views
            // possible
            return customMappableBody.customMap({
                $0.map(transform)
            }).flatMap({ $0 })
        } else {
            return [transform(body)]
        }
    }
    
    public func map<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        if let customMappableSelf = self as? CustomMappable {
            
            // This is where the recursion happens that makes composing TupleViews and ForEach views
            // possible
            return customMappableSelf.customMap({
                $0.map(transform)
            }).flatMap({ $0 })
        } else {
            return [transform(self)]
        }
    }
    
    public func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T] {
        return self.map {
            $0[keyPath: keyPath]
        }
    }
    
    public func deepMap<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        if let customMappableSelf = self as? CustomMappable {

            return customMappableSelf.customMap({
                $0.deepMap(transform)
            }).flatMap({ $0 })
        } else {
            if type(of: Body.self) != type(of: Never.self) {
                return body.deepMap(transform) + [transform(self)]
            } else {
                return [transform(self)]
            }
        }
    }
}


// MARK: Debugging

public extension View {
    func withDebugReference(_ action: (Self) -> ()) -> Self {
        action(self)
        return self
    }
}