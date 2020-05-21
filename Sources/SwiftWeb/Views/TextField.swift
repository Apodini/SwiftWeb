//
//  TextField.swift
//  
//
//  Created by Quirin Schweigert on 29.03.20.
//

import Foundation

/// A control that displays an editable text interface.
public struct TextField: View, ChangeInputEventResponder {
    public typealias Body = Never
    
    let title: String
    let text: Binding<String>
    
    public func onChangeInputEvent(newValue: String) {
        text.wrappedValue = newValue
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        return .input(placeholder: title, value: text.wrappedValue, style: [.pointerEvents: .auto])
    }
    
    /// Creates an instance with a title string and a binding for the editable value.
    public init<S>(_ title: S, text: Binding<String>) where S: StringProtocol {
        self.title = String(title)
        self.text = text
    }
    
    /// Creates an instance which passes the value of this `TextField` through the provided `Formatter`.
    public init<S, T>(_ title: S, value: Binding<T>, formatter: Formatter) where S: StringProtocol {
        self.title = String(title)
        
        self.text = Binding(getValue: {
            formatter.string(for: value.wrappedValue) ?? ""
        }, setValue: { (newText) in
            var parsedAnyObject: AnyObject? = nil
            var errorString: NSString? = nil
            
            formatter.getObjectValue(&parsedAnyObject, for: newText, errorDescription: &errorString)
            
            guard let parsedObject = parsedAnyObject as? T else {
                print("TextField formatter couldn't parse object")
                return
            }
            
            value.wrappedValue = parsedObject
        })
    }
}

/// The type of keyboard to display for a given text-based view.
public enum UIKeyboardType {
    /// Specifies a keyboard with numbers and a decimal point.
    case decimalPad
}

public extension View {
    func keyboardType(_ type: UIKeyboardType) -> some View {
        return self
    }
}
