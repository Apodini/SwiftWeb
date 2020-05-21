//
//  Edge.swift
//  
//
//  Created by Quirin Schweigert on 27.01.20.
//

import Foundation

/// An enumeration to indicate one edge of a rectangle.
public enum Edge: Int8, CaseIterable {
    /// The bottom edge.
    case bottom
    
    /// The leading edge.
    case leading
    
    /// The top edge.
    case top
    
    /// The trailing edge.
    case trailing
    
    /// An efficient set of `Edge`s.
    public struct Set: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// All edges.
        public static let all:         Self = [.bottom, .top, .leading, .trailing]
        
        /// The bottom edge.
        public static let bottom:      Self = .init(rawValue: 1 << Edge.bottom.rawValue)
        
        /// Horizontal edges.
        public static let horizontal:  Self = [.leading, .trailing]
        
        /// The leading edge.
        public static let leading:     Self = .init(rawValue: 1 << Edge.leading.rawValue)
        
        /// The top edge.
        public static let top:         Self = .init(rawValue: 1 << Edge.top.rawValue)
        
        /// The trailing edge.
        public static let trailing:    Self = .init(rawValue: 1 << Edge.trailing.rawValue)
        
        /// Vertical edges.
        public static let vertical:    Self = [.top, .bottom]
    }
}
