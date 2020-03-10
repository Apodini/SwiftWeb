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
    var isValid = true

    init(forView view: TypeErasedView, reconciling oldViewNode: ViewNode? = nil) {
        self.view = view
        subnodes = []

        if let oldViewNode = oldViewNode, type(of: view) == type(of: oldViewNode.view) {
            // transfer state to the new node
            stateStorageNode = oldViewNode.stateStorageNode
            
            // possibly reconcile deeper nodes
            subnodes = executeInStateContext { view in
                view.mapBody { subView in
                    // case of a single subview
                    if oldViewNode.subnodes.count == 1, let subnode = oldViewNode.subnodes.first {
                        return ViewNode(forView: subView, reconciling: subnode)
                    } else {
                        // if the type of the new view doesn't match we don't transfer state
                        return ViewNode(forView: subView)
                    }
                }
            }
        } else {
            // build subtree with new state
            stateStorageNode = StateStorageNode()
            subnodes = executeInStateContext { view in
                view.mapBody { subView in
                    ViewNode(forView: subView)
                }
            }
        }
        
        stateStorageNode.onChange = {
            self.isValid = false
        }
    }
    
    /**
     Put `view` into state context and render its HTML. Recursively render HTML of subnodes and hand the render functions an array
     of rendered HTML of the subcomponents so that composite views can compose it.
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
        
        if !isValid {
            rebuildSubtree()
        }
    }
    
    public func executeInStateContext<T>(_ transaction: (TypeErasedView) -> T) -> T {
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
    
    public func rebuildSubtree() {
        subnodes = executeInStateContext { view in
            view.mapBody { subView in
                if subnodes.count == 1, let subnode = subnodes.first {
                    return ViewNode(forView: subView, reconciling: subnode)
                } else {
                    return ViewNode(forView: subView)
                }
            }
        }
    }
}

extension ViewNode: CustomStringConvertible {
    public var description: String {
        if subnodes.isEmpty {
            return "<ViewNode: \(Self.simpleType(of: view)) \(stateStorageNode.state)/>"
        } else {
            return """
                <ViewNode: \(Self.simpleType(of: view)) \(stateStorageNode.state)>
                \(subnodes.map({ $0.description }).joined(separator: "\n").blockIndented())
                </ViewNode>
                """
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
                "   \($0)"
            }
            .joined(separator: "\n")
    }
}
