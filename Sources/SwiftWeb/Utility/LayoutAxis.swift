//
//  LayoutAxis.swift
//  
//
//  Created by Quirin Schweigert on 06.01.20.
//

import Foundation

/**
 Primary layout axis of a view. Used by the SwiftWeb layout system to translate `GrowingLayoutAxis`s  into CSS attributes at each level of the view hierarchy.
 */
public enum LayoutAxis {
    case horizontal
    case vertical
}

/**
 An an axis in which the layout of a view can be extended to fill the available space.
 
 The `undetermined` case is used by e.g. Spacers to indicate that its growing axes is only determined by a containing `HStack` or `VStack`
 
 The growing axes of a view can be modified by the view itself by implementing the `GrowingAxesModifying` protocol.
 */
public enum GrowingLayoutAxis {
    case undetermined
    case vertical
    case horizontal
}
