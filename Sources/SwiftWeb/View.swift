//
//  View.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

/// Type-erased `View` w.r.t. the `Body` associated type.
public protocol TypeErasedView {
    /// The primary layout axis of the view. This is used by the SwiftWeb layout system to generate CSS properties mimicking the
    /// SwiftUI layout system. By default, all HTML elements in SwiftWeb are aligned in the `.vertical` axis.
    var layoutAxis: LayoutAxis { get }
    
    /// Defines the generation of HTML representing the view.
    func html(forHTMLOfSubnodes: [HTMLNode]) -> HTMLNode
    
    /// Transforms this view with the supplied closure argument. Can be overridden by `View`s by implementing the
    /// `CustomMappable` protocol in order to represent multiple subviews. This method is used by SwiftWeb for instantiating the
    /// view tree during runtime.
    func map<T>(_ transform: (TypeErasedView) -> T) -> [T]
    
    /// Helper method which transforms the `body` of a view if the `Body` type is not equal to `Never`, returns an empty array
    /// otherwise.
    func mapBody<T>(_ transform: (TypeErasedView) -> T) -> [T]
}

/**
 A type that represents part of your app’s user interface and provides modifiers that you use to configure views.
 
 You create custom views by declaring types that conform to the `View` protocol. Implement the required `body` computed property to provide the content for your custom view.
 */
public protocol View: TypeErasedView {
    /// The type of the `body` property defining the subtree of `View`s of this `View`.
    associatedtype Body: View
    
    /// The body property is used to delegate the generation of html for a specific node to another view. It should be set for all view
    /// which enclose other views in order to allow the layout system to propagate properties properly through the tree.
    var body: Body { get }
}

public extension View {
    var layoutAxis: LayoutAxis {
        .vertical
    }
    
    var body: some View {
        EmptyView()
    }
}

public extension View {
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes.joined()
    }
}

/**
 This extension makes the `Never` type conform to `View` so that it can be used as the associated `Body` type of the latter for `View`s without subviews.
 */
extension Never: View {
    public var body: Never { fatalError("Never Type has no body") }
}

/// The `EmptyView` is used by the `ViewBuilder` as a return value for empty blocks.
public struct EmptyView: View {
    public typealias Body = Never
}

public extension View where Body == Never {
    var body: Never { fatalError("\(type(of: self)) has no body") }
}

/// Implement this protocol with your `View` to define the elements to which a transformation of this view is applied.
public protocol CustomMappable {
    /// Use the `customMap(_:)` method to e.g. give access to multiple subviews which this view represents. This method is used
    /// to construct the view tree during runtime.
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
            return customMappableBody
                .customMap {
                    $0.map(transform)
                }
                .flatMap {
                    $0
                }
        } else {
            return [transform(body)]
        }
    }
    
    public func map<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        if let customMappableSelf = self as? CustomMappable {
            // This is where the recursion happens that makes composing TupleViews and ForEach views
            // possible
            return customMappableSelf
                .customMap {
                    $0.map(transform)
                }
                .flatMap {
                    $0
                }
        } else {
            return [transform(self)]
        }
    }
    
    /// Default implementation of `map(_:)` which 
    public func map<T>(_ keyPath: KeyPath<TypeErasedView, T>) -> [T] {
        self.map {
            $0[keyPath: keyPath]
        }
    }
}

// MARK: View modifiers

public extension View {
    /// Clips the view to its bounding frame, with the specified corner radius.
    func cornerRadius(_ radius: Double) -> some View {
        ModifiedContent(content: self, modifier: HTMLTransformingViewModifier { html in
            html
                .withStyle(key: .borderRadius, value: .px(radius))
                .withStyle(key: .overflow, value: .hidden)
        })
    }
    
    /// Adds a shadow to the view.
    func shadow(color: Color = Color(white: 0.0).opacity(0.20),
                radius: Double = 40.0,
                x: Double = 0.0,
                y: Double = 2.0
    ) -> some View {
        ModifiedContent(content: self, modifier: HTMLTransformingViewModifier { html in
            html.withStyle(key: .boxShadow,
                           value: .shadow(offsetX: x,
                                          offsetY: y,
                                          radius: radius,
                                          color: color))
        })
    }
    
    /// Pads the view using the specified edge insets.
    func padding(_ edges: Edge.Set = .all, _ length: Double? = nil) -> some View {
        let length = length ?? 10.0
        
        let paddingPropertyMapping: [(cssKey: HTMLNode.CSSKey, edgeSet: Edge.Set)] = [
            (.paddingTop, .top),
            (.paddingLeft, .leading),
            (.paddingRight, .trailing),
            (.paddingBottom, .bottom)
        ]
        
        let paddingStyle = Dictionary(uniqueKeysWithValues: paddingPropertyMapping.compactMap {
            edges.contains($0.edgeSet) ? ($0.cssKey, HTMLNode.CSSValue.px(length)) : nil
        })
        
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier { html in
            .div(
                subNodes: [
                    html
                        .withStyle(key: .flexGrow, value: .one)
                        .withStyle(key: .alignSelf, value: .stretch)
                ],
                style: paddingStyle
            )
        })
    }
    
    /// Pads the view using the specified length.
    func padding(_ length: Double? = nil) -> some View {
        padding(.all, length)
    }
    
    /// Adds a border to the view with the specified style and width.
    func border(_ color: Color, width: Double = 1) -> some View {
        ModifiedContent(content: self, modifier: HTMLTransformingViewModifier { html in
            html.withStyle(key: .border,
                           value: .border(width: width, color: color))
        })
    }
}


// MARK: View description
    
public extension TypeErasedView {
    /// Description of this view instance.
    var debugDescription: String {
        String(describing: Self.self)
    }
}

extension View {
    func withDebugReference(_ action: (Self) -> Void) -> Self {
        action(self)
        return self
    }
}
