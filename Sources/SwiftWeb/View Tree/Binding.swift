//
//  Binding.swift
//  
//
//  Created by Quirin Schweigert on 17.03.20.
//

import Foundation

@propertyWrapper public struct Binding<Value> {
    private var getValue: () -> Value
    private var setValue: (Value) -> Void
    
    public var wrappedValue : Value {
        get {
            getValue()
        }

        nonmutating set {
            setValue(newValue)
        }
    }
    
    public init(getValue: @escaping () -> Value, setValue: @escaping (Value) -> Void) {
        self.getValue = getValue
        self.setValue = setValue
    }
}
