//
//  VStack.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct VStack<Content>: Stack, GrowingAxesModifying where Content: View {
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
    
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> {
        // .undetermined means that there is a spacer among the subviews which is not contained in another stack. This
        // means that this horizontal stack view can grow among its primary axis.
        Set(body.growingLayoutAxes.map { $0 == .undetermined ? .vertical : $0 })
    }
    
    public init(alignment: HorizontalAlignment = .center,
                spacing: Double? = nil,
                @ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        horizontalAlignment = alignment
        subnodes = Self.insertSpacers(forSpacing: spacing,
                                      inNodes: body.map { $0.html(inLayoutAxis: .vertical) },
                                      axis: .vertical)
    }
}

public enum HorizontalAlignment {
    case center
    case leading
    case trailing
    
    var cssValue: HTMLNode.CSSValue {
        switch self {
        case .center:
            return .center
        case .leading:
            return .flexStart
        case .trailing:
            return .flexEnd
        }
    }
}
