//
//  State.swift
//  
//
//  Created by Quirin Schweigert on 08.03.20.
//

import Foundation

protocol TypeErasedState: class {
    func connect(to stateStorageNode: StateStorageNode, withPropertyName propertyName: String)
    func disconnect()
}

/**
 A property wrapper type that can read and write a value managed by SwiftWeb.
 
 SwiftWeb manages the storage of any property you declare as a state. When the state value changes, the view invalidates its appearance
 and recomputes the body. Use the state as the single source of truth for a given view.
 
 A State instance isn’t the value itself; it’s a means of reading and writing the value. To access a state’s underlying value, use its variable
 name, which returns the `wrappedValue` property value.
 
 You should only access a state property from inside the view’s body, or from methods called by it.
 */
@propertyWrapper public class State<Value>: TypeErasedState {
    let defaultValue: Value
    
    private var propertyName: String? = nil
    private var stateStorageNode: StateStorageNode? = nil
    
    /// The underlying value referenced by the state variable.
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
    
    func connect(to stateStorageNode: StateStorageNode,
                        withPropertyName propertyName: String) {
        self.propertyName = propertyName
        self.stateStorageNode = stateStorageNode
        
        if stateStorageNode.getProperty(forKey: propertyName) == nil {
            stateStorageNode.setProperty(value: defaultValue, forKey: propertyName)
        }
    }
    
    func disconnect() {
        self.propertyName = nil
        self.stateStorageNode = nil
    }
    
    /// Creates the state with an initial wrapped value.
    public init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }
    
    /// Returns the `binding` property of the `State` instance.
    public var projectedValue: Binding<Value> {
        return binding
    }

    /// A binding to the state value.
    public var binding: Binding<Value> {
        return Binding(
            getValue: { self.wrappedValue },
            setValue: { self.wrappedValue = $0 }
        )
    }
}
