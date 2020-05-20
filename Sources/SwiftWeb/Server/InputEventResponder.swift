//
//  InputEventResponder.swift
//  
//
//  Created by Quirin Schweigert on 30.03.20.
//

import Foundation

protocol InputEventResponder { }

/// Implement this protocol with your `View` to receive HTML click events.
public protocol ClickInputEventResponder {
    func onClickInputEvent()
}

/// Implement this protocol with your `View` to receive HTML change events.
public protocol ChangeInputEventResponder {
    func onChangeInputEvent(newValue: String)
}
