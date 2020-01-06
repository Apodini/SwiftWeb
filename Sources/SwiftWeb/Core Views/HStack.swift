//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack: Stack {
    public let body: View? = nil
    let subviews: [View]
    
    public var html: HTMLNode {
        let subNodes = subviews.map(\.html)
        
        // propagate growing parameters to imitate SwiftUI layout behaviour
        let growingSubNodes = subNodes.map {
            $0.shouldGrow ? $0.withAddedStyle(key: .alignSelf, value: .center) ?? $0 : $0
        }
        
        return .div(subNodes: growingSubNodes, style: [
            .display: .flex,
            .flexDirection: .row,
            .flexGrow: subNodes.shouldGrow ? .one : .zero
        ])
    }
    
    public init(spacing: Double? = nil, @StackFunctionBuilder buildSubviews: () -> [View]) {
        self.subviews = Self.insertSpacers(forSpacing: spacing, in: buildSubviews(), horizontally: true)
    }
}
