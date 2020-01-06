//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack: Stack {
    public var body: View? = nil
    let subviews: [View]
    
    public var html: HTMLNode {
        .div(subNodes: subviews.map(\.html), style: [
            .display: "flex",
            .flexDirection: "row",
        ])
    }
    
    public init(spacing: Double? = nil, @StackFunctionBuilder buildSubviews: () -> [View]) {
        self.subviews = Self.insertSpacers(forSpacing: spacing, in: buildSubviews(), horizontally: true)
    }
}
