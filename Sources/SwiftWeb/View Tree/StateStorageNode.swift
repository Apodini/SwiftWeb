//
//  StateStorageNode.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

class StateStorageNode {
    let viewInstanceID = UUID()
    var state: [String: Any] = [:]
    var onChange: (() -> Void)?

    func setProperty(value: Any, forKey key: String) {
        state[key] = value
        onChange?()
    }
    
    func getProperty(forKey key: String) -> Any? {
        state[key]
    }
}
