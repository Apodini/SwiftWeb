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
            subnodes = buildSubtree(forView: view, reconcilingSubnodes: oldViewNode.subnodes)
        } else {
            // build subtree with new state
            stateStorageNode = StateStorageNode()
            subnodes = buildSubtree(forView: view, reconcilingSubnodes: [])
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
            // rebuild the subtree while reconciling existing subnodes
            subnodes = buildSubtree(forView: view, reconcilingSubnodes: subnodes)
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
    
    func buildSubtree(forView view: TypeErasedView,
                      reconcilingSubnodes oldSubnodes: [ViewNode]) -> [ViewNode] {
        executeInStateContext { view in
            let newSubviews = view.mapBody { $0 }
            
            // for now, if the number of subviews matches, we match pairs at the same indices
            if oldSubnodes.count == newSubviews.count {
                return zip(newSubviews, oldSubnodes).map { (newSubview, oldSubnode) in
                    return ViewNode(forView: newSubview, reconciling: oldSubnode)
                }
            } else {
                return newSubviews.map { subview in
                    ViewNode(forView: subview)
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
