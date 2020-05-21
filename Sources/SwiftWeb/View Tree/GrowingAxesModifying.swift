//
//  GrowingAxesModifying.swift
//  
//
//  Created by Quirin Schweigert on 16.03.20.
//

import Foundation

/**
 Implement this protocol with your `View` in order to customize its set of `GrowingLayoutAxis`.
 */
public protocol GrowingAxesModifying {
    /// Defines the set of `GrowingLayoutAxis` depending on the set of `GrowingLayoutAxis` of the subnodes of this view.
    func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis>
}
