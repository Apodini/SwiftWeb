//
//  InputEventResponder.swift
//  
//
//  Created by Quirin Schweigert on 30.03.20.
//

import Foundation

protocol InputEventResponder { }

protocol ClickInputEventResponder {
    func onClickInputEvent()
}

protocol ChangeInputEventResponder {
    func onChangeInputEvent(newValue: String)
}
