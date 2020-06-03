//
//  VStack.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

/// A view that arranges its children in a vertical line.
public struct VStack<Content>: Stack, GrowingAxesModifying where Content: View {
    public let body: Content
    let horizontalAlignment: HorizontalAlignment
    let spacing: Double?
    
    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes growingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis> {
            // `.undetermined` means that there is a spacer among the subviews which is not
            // contained in another stack. This means that this horizontal stack view can grow among
            // its primary axis.
            Set(growingAxesOfSubnodes.map { $0 == .undetermined ? .vertical : $0 })
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
            inNodes: htmlOfSubnodes, // in vertical layout axis?
            axis: .vertical
        )
        
        return .div(subNodes: htmlOfSpacedSubnodes, style: [
            .display: .flex,
            .flexDirection: .column,
            .alignItems: horizontalAlignment.cssValue
        ])
    }
}

/// An alignment position along the horizontal axis.
public enum HorizontalAlignment {
    /// A guide marking the horizontal center of the view.
    case center
    
    /// A guide marking the leading edge of the view.
    case leading
    
    /// A guide marking the trailing edge of the view.
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
