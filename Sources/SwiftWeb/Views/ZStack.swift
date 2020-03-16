//
//  ZStack.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct ZStack<Content>: Stack, GrowingAxesModifying where Content: View {
    public let body: Content
    
    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis> {
            [.vertical, .horizontal]
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        let stackedSubnodes = htmlOfSubnodes.map { node -> HTMLNode in // TODO htmlofsubnodes in vertical layout axis
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
    }
}

public extension View {
    func background<Background>(_ background: Background) -> some View where Background: View {
        guard let backgroundColor = background as? Color else {
            fatalError("not supported")
        }
        
        return ModifiedContent(content: self, modifier: HTMLTransformingViewModifier() { html in
            html.withStyle(
                key: .backgroundColor,
                value: .color(backgroundColor)
            )
        })
    }
    
    func globalOverlay<Overlay>(@ViewBuilder _ overlay: () -> Overlay) -> some View where Overlay: View {
        return TupleView((
            self,
            ModifiedContent(content: overlay(), modifier: HTMLTransformingViewModifier() { html in
                html
                    .withStyle(key: .position, value: .fixed)
                    .withStyle(key: .top, value: .zero)
                    .withStyle(key: .right, value: .zero)
                    .withStyle(key: .bottom, value: .zero)
                    .withStyle(key: .left, value: .zero)
            })
        ))
    }
}
