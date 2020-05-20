//
//  ViewNode.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

class ViewNode {
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
        
//        provideViewPreferences()
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
        return executeInStateContext { view in
            let htmlOfSubnodes = subnodes.map { subnode in
                return Self.applyGrowingProperties(toHTMLNode: subnode.render(),
                                                   forGrowingLayoutAxes: subnode.growingLayoutAxes,
                                                   inLayoutAxis: view.layoutAxis)
            }
            
            var html = view.html(forHTMLOfSubnodes: htmlOfSubnodes)
                .withCustomAttribute(key: "view", value: Self.simpleType(of: view))
            
            if view is ClickInputEventResponder {
                html = html
                    .withCustomAttribute(key: "click-event-responder")
                    .withCustomAttribute(key: "id", value: stateStorageNode.viewInstanceID.uuidString)
                    .withStyle(key: .pointerEvents, value: .auto)
            }
            
            if view is ChangeInputEventResponder {
                html = html
                    .withCustomAttribute(key: "change-event-responder")
                    .withCustomAttribute(key: "id", value: stateStorageNode.viewInstanceID.uuidString)
            }

            return html
        }
    }
    
    public func handle(inputEvent: InputEvent) {
        executeInStateContext { view in
            switch inputEvent {
            case .click(let id):
                if id == stateStorageNode.viewInstanceID,
                   let clickInputEventResponder = view as? ClickInputEventResponder {
                    clickInputEventResponder.onClickInputEvent()
                }
            case .change(let id, let newValue):
                if id == stateStorageNode.viewInstanceID,
                    let changeInputEventResponder = view as? ChangeInputEventResponder {
                    changeInputEventResponder.onChangeInputEvent(newValue: newValue)
                }
            }
            
            subnodes.forEach { subnode in
                subnode.handle(inputEvent: inputEvent)
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
    
    func findPreferenceValue<P>(forKey preferenceKey: P.Type) -> P.Value? where P: PreferenceKey {
        let preferenceValueOfSubviews: P.Value? = subnodes.reduce(nil) {
            (accumulatorValue, subnode) -> P.Value? in
            let preferenceValueOfSubnode = subnode.findPreferenceValue(forKey: preferenceKey)
            
            // do we need to combine preference values because both accumulator and
            // preferenceValueOfSubnode are present?
            if let previousValue = accumulatorValue,
                let valueOfSubnode = preferenceValueOfSubnode {
                var value: P.Value = previousValue
                
                // reduce sibling preference values
                P.reduce(value: &value) {
                    valueOfSubnode
                }
                
                // return the combined value
                return value
            }
            
            // return the one which is present
            return preferenceValueOfSubnode ?? accumulatorValue
        }
        
        let preferenceValueOfThisView: P.Value?
        
        // is the view that this node is holding providing a preference value for the supplied key?
        if let preferenceProviderView = view as? PreferenceProvider,
            preferenceProviderView.preferenceKeyType == P.self {
            preferenceValueOfThisView = preferenceProviderView.preferenceValue as? P.Value
        } else {
            preferenceValueOfThisView = nil
        }
        
        if let preferenceValueOfThisView = preferenceValueOfThisView,
            let preferenceValueOfSubviews = preferenceValueOfSubviews {
            var value: P.Value = preferenceValueOfSubviews
            
            // reduce preference value of subnodes and parent node
            P.reduce(value: &value) {
                preferenceValueOfThisView
            }
            
            return value
        }
        
        return preferenceValueOfThisView ?? preferenceValueOfSubviews
    }
    
//    func provideViewPreferences() {
//        if let preferenceChangeListener = view as? PreferenceChangeListener {
////            preferenceChangeListener.onPreferenceChange(
////                preferenceValue: findPreferenceValue(forKey: preferenceChangeListener.preferenceKey)
////            )
//            let preferenceValue = findPreferenceValue(forKey: preferenceChangeListener.)
//        }
//    }
}
