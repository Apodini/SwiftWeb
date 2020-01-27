//
//  View.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public protocol TypeErasedView {
    var html: HTMLNode { get }
    var growingLayoutAxes: Set<GrowingLayoutAxis> { get }
    func html(inLayoutAxis: LayoutAxis) -> HTMLNode
}

public protocol View: TypeErasedView {
    associatedtype Body: View
    
    // The body property is used to delegate the generation of html for a specific node to another view. It should be
    // set for all view which enclose other views in order to allow the layout system to propagate properties properly
    // through the tree.
    var body: Body { get }
}

// MARK: View body default implementation

public extension View {
    var body: some View {
        return EmptyView()
    }
}

public extension View {
    var html: HTMLNode {
        body.html
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
        return ModifiedView(body: self, newHTML: html.withAddedStyle(key: .borderRadius, value: .px(radius)))
    }
    
    func shadow(color: Color, radius: Double, x: Double, y: Double) -> some View {
        return ModifiedView(
            body: self,
            newHTML: html.withAddedStyle(key: .boxShadow,
                                value: .shadow(offsetX: x,
                                               offsetY: y,
                                               radius: radius,
                                               color: color))
        )
    }
    
    func padding(_ length: Double? = nil) -> some View {
        let length = length ?? 10.0
        
        return ModifiedView(body: self, newHTML: .div(subNodes: [html.withAddedStyle(key: .flexGrow, value: .one).withAddedStyle(key: .alignSelf, value: .stretch)], style: [.padding : .px(length)]))
    }
    
    func border(_ color: Color, width: Double = 1) -> some View {
        return ModifiedView(body: self,
                            newHTML: html.withAddedStyle(key: .border,
                                                         value: .border(width: width, color: color))
        )
    }
}


// MARK: View description

public extension View {
    var description: String {
        if type(of: Body.self) == type(of: Never.self) {
            return "\(String(describing: Self.self)){ body: Never }"
        } else {
            return "\(String(describing: Self.self)){ body: \(body.description), layoutGrowthAxes: \(growingLayoutAxes.description) }"
        }
    }
}


// MARK: View layout growth axes

public protocol GrowingAxesModifying {
    var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> { get }
}

public extension View {
    var growingLayoutAxes: Set<GrowingLayoutAxis> {
        if let growingAxesModifyingSelf = self as? GrowingAxesModifying {
            return growingAxesModifyingSelf.modifiedGrowingLayoutAxes
        } else if Body.self != Never.self {
            return body.growingLayoutAxes
        } else {
            return []
        }
    }
}

//public extension View {
//    var layoutGrowthAxes: Set<LayoutGrowthAxis> {
//        var growAxes = body.layoutGrowthAxes
//
//        if self is VStack<Body> {
//            if growAxes.contains(.undetermined) { // .undetermined means that there is a spacer among the subviews
//                                                  // which is not contained in another stack.
//                growAxes.remove(.undetermined)
//                growAxes.insert(.vertical) // This means that this horizontal stack view can grow among its
//                                           // primary axis.
//            }
//        } else if self is HStack<Body> {
//            if growAxes.contains(.undetermined) {
//                growAxes.remove(.undetermined)
//                growAxes.insert(.horizontal)
//            }
//        }
//
//        return growAxes
//    }
//}
//
//public extension View where Body == Never {
//    var layoutGrowthAxes: Set<LayoutGrowthAxis> {
//        if self is Spacer {
//            return [.undetermined]
//        } else if let tupleViewSelf = self as? TypeErasedTupleView {
//            return tupleViewSelf.map(\.layoutGrowthAxes).reduce([]) { accumulator, growthAxes in
//                accumulator.union(growthAxes)
//            }
//        } else {
//            return []
//        }
//    }
//}

public extension View {
    func html(inLayoutAxis: LayoutAxis) -> HTMLNode {
        return growingLayoutAxes.reduce(html) { html, growthAxis in
            switch (growthAxis, inLayoutAxis) {
            case (.horizontal, .horizontal), (.vertical, .vertical):         // For aligned axis of the layout direction of the parent
                return html.withAddedStyle(key: .flexGrow, value: .one)      // node and this node the html node can grow along the primary axis.
            case (.vertical, .horizontal), (.horizontal, .vertical):
                return html.withAddedStyle(key: .alignSelf, value: .stretch) // For the perpendicular case it needs to stretch across the secondary axis.
            case (.undetermined, _):
                return html.withAddedStyle(key: .flexGrow, value: .one)
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
