//
//  Spacer.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Spacer: View, GrowingAxesModifying {
    
    public typealias Body = Never
    
    public let html: HTMLNode
    
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> {
        // A Spacer can grow horizontally as well as vertically, dependent on the primary axis of
        // the containing stack view.
        [.undetermined]
    }

    public init() {
        html = .div()
    }
}
