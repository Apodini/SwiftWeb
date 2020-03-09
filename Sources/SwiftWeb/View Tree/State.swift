//
//  State.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

protocol TypeErasedState: class {
    var propertyName: String? { get set }
    var stateStorageNode: StateStorageNode? { get set }
}

@propertyWrapper public class State<Value>: TypeErasedState {
    var propertyName: String? = nil
    var stateStorageNode: StateStorageNode? = nil
    let defaultValue: Value
    
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
    
    public init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }
}
