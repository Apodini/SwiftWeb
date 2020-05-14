//
//  InputEventResponder.swift
//  
//
//  Created by Quirin Schweigert on 30.03.20.
//

import Foundation

protocol InputEventResponder { }

public protocol ClickInputEventResponder {
    func onClickInputEvent()
}

public protocol ChangeInputEventResponder {
    func onChangeInputEvent(newValue: String)
}
