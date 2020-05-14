//
//  StateStorageNode.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

public class StateStorageNode {
    public let viewInstanceID = UUID()
    public var state: [String: Any] = [:]
    public var onChange: (() -> Void)?

    func setProperty(value: Any, forKey key: String) {
//        let oldValue = state[key]
        state[key] = value
        
//        if let oldValue = oldValue,
//           let oldValueEquatable = oldValue as? Equatable,
//           let valueEquatable = value as? Equatable,
//           oldValueEquatable == valueEquatable {
//            return
//        } else {
            onChange?()
//        }
    }
    
    func getProperty(forKey key: String) -> Any? {
        state[key]
    }
}
