//
//  ViewTree.swift
//  
//
//  Created by Quirin Schweigert on 05.03.20.
//

import Foundation

class ViewTree {
    let rootNode: ViewNode
    
    init(withRootView rootView: TypeErasedView) {
        rootNode = ViewNode(forView: rootView)
    }
    
    func render() -> HTMLNode {
        rootNode.render()
    }
    
    func handle(inputEvent: InputEvent) {
        rootNode.handle(inputEvent: inputEvent)
    }
}

extension ViewTree: CustomStringConvertible {
    var description: String {
        rootNode.description
    }
}
