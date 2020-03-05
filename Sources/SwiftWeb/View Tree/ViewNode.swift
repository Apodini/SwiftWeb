//
//  StateContainer.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

public class ViewNode {
    public var view: TypeErasedView
    public var state: [String: Any] {
        didSet {
            print(state)
        }
    }
    public var subContainers: [ViewNode]
    
    init(view: TypeErasedView) {
        self.view = view
        state = view.initialState
        subContainers = []
    }
    
    /**
     Put `view` into state context and render its HTML.
     TODO: recursively render HTML of subnodes and make the render functions take an array of rendered HTML of the subcomponents
     so that composite views can use that.
     */
    public func render() -> HTMLNode {
        view.viewNode = self
        return view.html
    }
    
    public func handleEvent(withID id: String) {
        if let tapGestureView = view as? TypeErasedTapGestureView,
           id == tapGestureView.tapGestureViewID {
            tapGestureView.action()
        }
    }
    
    public func setState(_ newState: [String: Any]) {
        for (key, value) in newState {
            state[key] = value
        }
    }
}
