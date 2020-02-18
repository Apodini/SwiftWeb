//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct ZStack<Content>: Stack, GrowingAxesModifying where Content: View {
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> = [.vertical, .horizontal]
    
    public let body: Content
    
    public var subnodes: [HTMLNode] = []
    
    public var html: HTMLNode {
        let stackedSubnodes = subnodes.map { node -> HTMLNode in
            .div(style: [
                    .position: .absolute,
                    .width: .percent(100),
                    .height: .percent(100),
                    .display: .flex,
                    .flexDirection: .column,
                ]) {
                node
            }
        }
        
        return .div(subNodes: stackedSubnodes, style: [.position : .relative, .flexGrow: .one])
    }
    
    public init(@ViewBuilder content: () -> Content) {
        body = content()
        subnodes = body.map { $0.html(inLayoutAxis: .vertical) }
    }
}

public extension View {
    func background<Background>(_ background: Background) -> some View where Background: View {
        guard let backgroundColor = background as? Color,
            case .div(let subNodes, let style) = html else {
            fatalError("not supported")
        }
        
        var newStyle = style
        newStyle[.backgroundColor] = .color(backgroundColor)

        return ModifiedView(body: self, newHTML: .div(subNodes: subNodes, style: newStyle))
    }
    
    func globalOverlay<Overlay>(@ViewBuilder _ overlay: () -> Overlay) -> some View where Overlay: View {
        let overlay = overlay()
        
        return TupleView((
            self,
            ModifiedView(
                body: overlay,
                newHTML: overlay.html
                    .withAddedStyle(key: .position, value: .fixed)
                    .withAddedStyle(key: .top, value: .zero)
                    .withAddedStyle(key: .right, value: .zero)
                    .withAddedStyle(key: .bottom, value: .zero)
                    .withAddedStyle(key: .left, value: .zero)
            )
        ))
    }
}
