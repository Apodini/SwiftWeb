//
//  ViewTree.swift
//  
//
//  Created by Quirin Schweigert on 05.03.20.
//

import Foundation

class ViewTree {
    let rootNode: ViewNode
    
    init(rootView: TypeErasedView) {
        rootNode = ViewNode(view: rootView)
    }
}
