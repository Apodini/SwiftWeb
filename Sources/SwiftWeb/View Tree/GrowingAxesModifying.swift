//
//  GrowingAxesModifying.swift
//  
//
//  Created by Quirin Schweigert on 16.03.20.
//

import Foundation

/**
 Implement this protocol with your `View` in order to spefify its set of `GrowingLayoutAxis` depending on the `GrowingLayoutAxis`s as defined by its subtree of `View`s.
 */
public protocol GrowingAxesModifying {
    func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis>
}
