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
     To adapt the SwiftUI layout system (the effect of Spacers and growing properties of views in general) we keep track of the set of
     growing axes for each view which we propagate through the view tree. This property is used when rendering to set CSS properties
     accordingly at each node of the tree.
     */
    var growingLayoutAxes: Set<GrowingLayoutAxis> { // TODO: buffer this
        let growingLayoutAxesOfSubnodes = subnodes
            .map(\.growingLayoutAxes)
            .reduce(Set<GrowingLayoutAxis>()) { accumulator, growthAxes in
                accumulator.union(growthAxes)
        }
        
        if let growingAxesModifyingView = view as? GrowingAxesModifying {
            return growingAxesModifyingView
                .modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: growingLayoutAxesOfSubnodes)
        }
        
        return growingLayoutAxesOfSubnodes
    }
    
    /**
     Put `view` into state context and render its HTML. Recursively render HTML of subnodes and hand the render functions an array
     of rendered HTML of the subcomponents so that composite views can compose it. While rendering, keep track of the growing axes
     of the view which can be determined by `View ` by implementing the protocol `GrowingLayoutAxesModifying`.
     */
    public func render() -> HTMLNode {
        let htmlOfSubnodes = subnodes.map { subnode in
            return Self.applyGrowingProperties(toHTMLNode: subnode.render(),
                                               forGrowingLayoutAxes: subnode.growingLayoutAxes,
                                               inLayoutAxis: view.layoutAxis)
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
    
    /**
     Apply CSS properties to `toHTMLNode` to make it grow in `forGrowingLayoutAxes` when placed in a CSS flex layout with
     the layout axis `inLayoutAxis`.
     */
    static func applyGrowingProperties(toHTMLNode htmlNode: HTMLNode,
                                       forGrowingLayoutAxes growingLayoutAxes: Set<GrowingLayoutAxis>,
                                       inLayoutAxis parentLayoutAxis: LayoutAxis) -> HTMLNode {
        growingLayoutAxes.reduce(htmlNode) { html, growthAxis in
            switch (growthAxis, parentLayoutAxis) {
                
            // For aligned axis of the layout direction of the parent node and this node the html
            // node can grow along the primary axis.
            case (.horizontal, .horizontal), (.vertical, .vertical):
                return html.withStyle(key: .flexGrow, value: .one)
                
            // For the perpendicular case it needs to stretch across the
            // secondary axis.
            case (.vertical, .horizontal), (.horizontal, .vertical):
                return html.withStyle(key: .alignSelf, value: .stretch)
                
            case (.undetermined, _):
                return html.withStyle(key: .flexGrow, value: .one)
            }
        }
    }
}

extension ViewNode: CustomStringConvertible {
    public var description: String {
        var descriptionOfThisNode = "\(Self.simpleType(of: view)) \(stateStorageNode.state)"
        
        if let text = view as? Text {
            descriptionOfThisNode += " \"\(text.text)\""
        }
        
        if subnodes.isEmpty {
            return "<ViewNode: \(descriptionOfThisNode)/>"
        } else {
            return """
                <ViewNode: \(descriptionOfThisNode)>
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
