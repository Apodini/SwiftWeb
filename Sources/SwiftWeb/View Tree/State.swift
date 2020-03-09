//
//  State.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

public protocol TypeErasedState: class {
    func connect(to stateStorageNode: StateStorageNode, withPropertyName propertyName: String)
    func disconnect()
}

@propertyWrapper public class State<Value>: TypeErasedState {
    let defaultValue: Value
    
    private var propertyName: String? = nil
    private var stateStorageNode: StateStorageNode? = nil
    
    public var wrappedValue: Value {
        get {
            guard let propertyName = propertyName, let stateStorageNode = stateStorageNode else {
                print("property name or state storage node not set!")
                return defaultValue
            }
            
            return stateStorageNode.getProperty(forKey: propertyName) as? Value ?? defaultValue
        }
        
        set {
            guard let propertyName = propertyName, let stateStorageNode = stateStorageNode else {
                print("property name or state storage node not set!")
                return
            }
            
            stateStorageNode.setProperty(value: newValue, forKey: propertyName)
        }
    }
    
    public func connect(to stateStorageNode: StateStorageNode,
                        withPropertyName propertyName: String) {
        self.propertyName = propertyName
        self.stateStorageNode = stateStorageNode
        
        if stateStorageNode.getProperty(forKey: propertyName) == nil {
            stateStorageNode.setProperty(value: defaultValue, forKey: propertyName)
        }
    }
    
    public func disconnect() {
        self.propertyName = nil
        self.stateStorageNode = nil
    }
    
    public init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }
}
