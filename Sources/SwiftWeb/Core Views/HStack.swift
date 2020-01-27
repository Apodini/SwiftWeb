//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack<Content>: Stack, GrowingAxesModifying where Content: View {
    public let body: Content
    
    public var subnodes: [HTMLNode] = []
    
    public var html: HTMLNode {
        .div(subNodes: subnodes, style: [
            .display: .flex,
            .flexDirection: .row,
        ])
    }
    
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> {
        // .undetermined means that there is a spacer among the subviews which is not contained in another stack. This
        // means that this horizontal stack view can grow among its primary axis.
        Set(body.growingLayoutAxes.map { $0 == .undetermined ? .horizontal : $0 })
    }
    
    public init(spacing: Double? = nil, @ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        subnodes = Self.insertSpacers(forSpacing: spacing,
                                      inNodes: Self.buildSubnodes(fromView: body, inLayoutAxis: .horizontal),
                                      axis: .horizontal)
    }
}
