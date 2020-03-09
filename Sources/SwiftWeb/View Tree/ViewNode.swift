//
//  StateContainer.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

public class ViewNode {
    public var view: TypeErasedView
    public let stateStorageNode: StateStorageNode
    public var subContainers: [ViewNode]
    
    init(view: TypeErasedView) {
        self.view = view
        stateStorageNode = StateStorageNode()
        subContainers = []
    }
    
    /**
     Put `view` into state context and render its HTML.
     TODO: recursively render HTML of subnodes and make the render functions take an array of rendered HTML of the subcomponents
     so that composite views can use that.
     */
    public func render() -> HTMLNode {
        executeInStateContext { view in
            view.html
        }
    }
    
    public func handleEvent(withID id: String) {
        executeInStateContext { view in
            if let tapGestureView = view as? TypeErasedTapGestureView,
                id == tapGestureView.tapGestureViewID {
                tapGestureView.action()
            }
        }
    }
    
    public func executeInStateContext<T>(transaction: (TypeErasedView) -> T) -> T {
        let viewMirror = Mirror(reflecting: view)
        
        // This ties all `@State` properties of the view to the `StateStorageNode` associated with
        // this `ViewNode`.
        for child in viewMirror.children {
            if let typeErasedState = child.value as? TypeErasedState {
                typeErasedState.propertyName = child.label
                typeErasedState.stateStorageNode = stateStorageNode
            }
        }
        
        // For testing we'll make sure to remove the reference for this storage container for now.
        // It might be intended behaviour to keep this reference though because then we could
        // make mutating view state from outside (e.g. a scheduled closure) work.
        defer {
            for child in viewMirror.children {
                if let typeErasedState = child.value as? TypeErasedState {
                    typeErasedState.stateStorageNode = nil
                }
            }
        }
        
        return transaction(view)
    }
}
