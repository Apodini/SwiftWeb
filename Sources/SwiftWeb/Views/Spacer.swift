//
//  Spacer.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

/// A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.
public struct Spacer: View, GrowingAxesModifying {
    public typealias Body = Never
    
    public init() { }
    
    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis> {
            // A Spacer can grow horizontally as well as vertically, dependent on the primary axis of
            // the containing stack view.
            [.undetermined]
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .div()
    }
}
