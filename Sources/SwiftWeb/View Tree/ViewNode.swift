//
//  StateContainer.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

public class ViewNode {
    public var view: TypeErasedView
    public var state: [String: Any]
    public var subContainers: [ViewNode]
    
    init(view: TypeErasedView) {
        self.view = view
        state = [:]
        subContainers = []
    }
}
