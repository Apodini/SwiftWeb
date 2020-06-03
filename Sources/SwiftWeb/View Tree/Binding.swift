//
//  Binding.swift
//  
//
//  Created by Quirin Schweigert on 17.03.20.
//

import Foundation

/// A property wrapper type that can read and write a value owned by a source of truth.
@propertyWrapper public struct Binding<Value> {
    private var getValue: () -> Value
    private var setValue: (Value) -> Void
    
    /// The underlying value referenced by the binding variable.
    public var wrappedValue: Value {
        get {
            getValue()
        }

        nonmutating set {
            setValue(newValue)
        }
    }
    
    /// A projection of the binding value that returns a binding.
    public var projectedValue: Self {
        self
    }
    
    /// Creates a binding with closures that read and write the binding value.
    public init(getValue: @escaping () -> Value, setValue: @escaping (Value) -> Void) {
        self.getValue = getValue
        self.setValue = setValue
    }
}
