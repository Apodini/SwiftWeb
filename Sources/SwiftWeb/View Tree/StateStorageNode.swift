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
        state[key] = value
        onChange?()
    }
    
    func getProperty(forKey key: String) -> Any? {
        state[key]
    }
}
