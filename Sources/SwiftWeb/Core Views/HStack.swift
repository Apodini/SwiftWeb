//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack<Content>: Stack where Content: View {
    public let body: Content
    
    public var subnodes: [HTMLNode] = []
    
    public var html: HTMLNode {
        .div(subNodes: subnodes, style: [
            .display: .flex,
            .flexDirection: .row,
            .flexGrow: subnodes.shouldGrow ? .one : .zero
        ])
    }
    
    public init(spacing: Double? = nil, @ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        subnodes = Self.insertSpacers(forSpacing: spacing, inNodes: Self.buildSubnodes(fromView: body), axis: .horizontal)
    }
}
