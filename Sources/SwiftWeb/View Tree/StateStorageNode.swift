//
//  StateStorageNode.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

public class StateStorageNode {
    public var state: [String: Any]
    
    init() {
        state = [:]
    }
    
    func setProperty(value: Any, forKey key: String) {
        state[key] = value
    }
    
    func getProperty(forKey key: String) -> Any? {
        state[key]
    }
}
