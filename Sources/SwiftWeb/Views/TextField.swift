//
//  TextField.swift
//  
//
//  Created by Quirin Schweigert on 29.03.20.
//

import Foundation

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
    
    public init<S>(_ title: S, text: Binding<String>) where S: StringProtocol {
        self.title = String(title)
        self.text = text
    }
    
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

public enum UIKeyboardType {
    case decimalPad
}

public extension View {
    func keyboardType(_ type: UIKeyboardType) -> some View {
        return self
    }
}
