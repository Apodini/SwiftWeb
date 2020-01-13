//
//  VStack.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct VStack<Content>: Stack where Content: View {
    public let body: Content
    
    public var subnodes: [HTMLNode] = []
    let horizontalAlignment: HorizontalAlignment
    
    public var html: HTMLNode {
        .div(subNodes: subnodes, style: [
            .display: .flex,
            .flexDirection: .column,
            .alignItems: horizontalAlignment.cssValue,
        ])
    }
    
    public init(alignment: HorizontalAlignment = .center,
                spacing: Double? = nil,
                @ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        horizontalAlignment = alignment
        subnodes = Self.insertSpacers(forSpacing: spacing, inNodes: Self.buildSubnodes(fromView: body), axis: .vertical)
    }
}

public enum HorizontalAlignment {
    case center
    case leading
    case trailing
    case stretch // needs to be substituted by spacer logic
    
    var cssValue: HTMLNode.CSSValue {
        switch self {
        case .center:
            return .center
        case .leading:
            return .flexStart
        case .trailing:
            return .flexEnd
        case .stretch:
            return .stretch
        }
    }
}
