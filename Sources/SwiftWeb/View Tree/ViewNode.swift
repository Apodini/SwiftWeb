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
    public var subnodes: [ViewNode]
    
    init(view: TypeErasedView) {
        self.view = view
        stateStorageNode = StateStorageNode()
        subnodes = view.mapBody { subView in
            ViewNode(view: subView)
        }
    }
    
    /**
     Put `view` into state context and render its HTML.
     TODO: recursively render HTML of subnodes and make the render functions take an array of rendered HTML of the subcomponents
     so that composite views can use that.
     */
    public func render() -> HTMLNode {
        let htmlOfSubnodes = subnodes.map { subnode in
            subnode.render()
        }
        
        return executeInStateContext { view in
            view.html(forHTMLOfSubnodes: htmlOfSubnodes)
        }
    }
    
    public func handleEvent(withID id: String) {
        executeInStateContext { view in
            if let tapGestureView = view as? TypeErasedTapGestureView,
                id == tapGestureView.tapGestureViewID {
                tapGestureView.action()
            }
            
            subnodes.forEach { subnode in
                subnode.handleEvent(withID: id)
            }
        }
    }
    
    public func executeInStateContext<T>(transaction: (TypeErasedView) -> T) -> T {
        let viewMirror = Mirror(reflecting: view)
        
        // This ties all `@State` properties of the view to the `StateStorageNode` associated with
        // this `ViewNode`.
        for child in viewMirror.children {
            if let typeErasedState = child.value as? TypeErasedState, let label = child.label {
                typeErasedState.connect(to: stateStorageNode, withPropertyName: label)
            }
        }
        
        // For testing we'll make sure to remove the reference for this storage container after the
        // transaction for now. It might be intended behaviour to keep this reference though because
        // then we could make mutating view state from outside (e.g. a scheduled closure) work.
        defer {
            for child in viewMirror.children {
                if let typeErasedState = child.value as? TypeErasedState {
                    typeErasedState.disconnect()
                }
            }
        }
        
        return transaction(view)
    }
}

extension ViewNode: CustomStringConvertible {
    public var description: String {
        if subnodes.isEmpty {
            return "<ViewNode: \(Self.simpleType(of: view)) \(stateStorageNode.state)/>"
        } else {
            return "<ViewNode: \(Self.simpleType(of: view)) \(stateStorageNode.state)>\n\(subnodes.map({ $0.description }).joined(separator: "\n").blockIndented())</ViewNode>"
        }
    }
    
    private static func simpleType(of value: Any) -> String {
        let typeString = String(describing: type(of: value))
        if let simpleTypeString = typeString.split(separator: "<").first {
            return String(simpleTypeString)
        } else {
            return typeString
        }
    }
}

extension String {
    func blockIndented() -> String {
        return self
            .split(separator: "\n")
            .map {
                "   \($0)\n"
            }
            .joined()
    }
}
