//
//  GrowingAxesModifying.swift
//  
//
//  Created by Quirin Schweigert on 16.03.20.
//

import Foundation

public protocol GrowingAxesModifying {
    func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>)
        -> Set<GrowingLayoutAxis>
}
