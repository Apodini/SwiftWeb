//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct ZStack<Content>: Stack where Content: View {
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
                    .alignItems: .stretch,
                ]) {
                node
            }
        }
        
        return .div(subNodes: stackedSubnodes, style: [.position : .relative, .flexGrow: .one])
    }
    
    public init(@ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        subnodes = Self.buildSubnodes(fromView: body)
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

        return ModifiedView(newHTML: .div(subNodes: subNodes, style: newStyle))
    }
}
