//
//  HStack.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack<Content>: Stack, GrowingAxesModifying where Content: View {
    public let body: Content
    let horizontalAlignment: HorizontalAlignment
    let spacing: Double?
    
    public var html: HTMLNode {
        .raw("not implemented")
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
        self.spacing = spacing
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        let htmlOfSpacedSubnodes = Self.insertSpacers(
            forSpacing: spacing,
            inNodes: htmlOfSubnodes, // in horizontal layout axis?
            axis: .horizontal
        )
        
        return .div(subNodes: htmlOfSpacedSubnodes, style: [
            .display: .flex,
            .flexDirection: .row,
            .alignItems: horizontalAlignment.cssValue,
        ])
    }
}

public enum VerticalAlignment {
    case center
    case top
    case bottom
    
    var cssValue: HTMLNode.CSSValue {
        switch self {
        case .center:
            return .center
        case .top:
            return .flexStart
        case .bottom:
            return .flexEnd
        }
    }
}
