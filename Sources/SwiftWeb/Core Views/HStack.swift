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
        ])
    }
    
    public var layoutGrowthAxes: Set<LayoutGrowthAxis> {
        var growAxes = body.layoutGrowthAxes
        
        if growAxes.contains(.undetermined) { // .undetermined means that there is a spacer among the subviews
                                              // which is not contained in another stack.
            growAxes.remove(.undetermined)
            growAxes.insert(.horizontal) // This means that this horizontal stack view can grow among its
                                         // primary axis.
        }
        
        return growAxes
    }
    
    public init(spacing: Double? = nil, @ViewBuilder buildSubviews: () -> Content) {
        body = buildSubviews()
        subnodes = Self.insertSpacers(forSpacing: spacing,
                                      inNodes: Self.buildSubnodes(fromView: body, inLayoutAxis: .horizontal),
                                      axis: .horizontal)
    }
}
