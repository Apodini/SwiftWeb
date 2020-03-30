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
    
    func onChangeInputEvent(newValue: String) {
        text.wrappedValue = newValue
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        print("rendering html for TextField with value: \"\(text.wrappedValue)\"")
        return .input(placeholder: title, value: text.wrappedValue, style: [.pointerEvents: .auto])
    }
    
    public init<S>(_ title: S, text: Binding<String>) where S: StringProtocol {
        self.title = String(title)
        self.text = text
    }
}
