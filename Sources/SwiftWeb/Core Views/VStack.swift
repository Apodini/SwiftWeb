//
//  VStack.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct VStack: Stack {
    public let body: View? = nil
    let subviews: [View]
    let horizontalAlignment: HorizontalAlignment
    
    public var html: HTMLNode {
        .div(subNodes: subviews.map(\.html), style: [
            .display: .flex,
            .flexDirection: .column,
            .alignItems: horizontalAlignment.cssValue,
        ])
    }
    
    public init(spacing: Double? = nil,
                alignment: HorizontalAlignment = .center,
                @StackFunctionBuilder buildSubviews: () -> [View]) {
        self.subviews = Self.insertSpacers(forSpacing: spacing, in: buildSubviews())
        self.horizontalAlignment = alignment
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
}
