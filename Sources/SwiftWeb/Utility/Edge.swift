//
//  Edge.swift
//  
//
//  Created by Quirin Schweigert on 27.01.20.
//

import Foundation

public enum Edge: Int8, CaseIterable {
    case bottom
    case leading
    case top
    case trailing
    
    public struct Set: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let all:         Self = [.bottom, .top, .leading, .trailing]
        public static let bottom:      Self = .init(rawValue: 1 << Edge.bottom.rawValue)
        public static let horizontal:  Self = [.leading, .trailing]
        public static let leading:     Self = .init(rawValue: 1 << Edge.leading.rawValue)
        public static let top:         Self = .init(rawValue: 1 << Edge.top.rawValue)
        public static let trailing:    Self = .init(rawValue: 1 << Edge.trailing.rawValue)
        public static let vertical:    Self = [.top, .bottom]
    }
}
