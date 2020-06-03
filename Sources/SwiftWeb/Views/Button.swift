//
//  Button.swift
//  
//
//  Created by Quirin Schweigert on 17.03.20.
//

import Foundation

/// A control that performs an action when triggered.
public struct Button<Label>: View where Label: View {
    let action: () -> Void
    let label: Label
    
    public var body: some View {
        label
            .systemBlueFilter()
            .onTapGesture(perform: action)
    }
    
    /// Creates an instance with a custom view as label.
    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
}

public extension Button where Label == Text {
    /// Creates an instance with a string as label.
    init<S>(_ title: S, action: @escaping () -> Void) where S: StringProtocol {
        self = .init(action: action) {
            Text(String(title))
        }
    }
}

public extension View {
    func disabled(_ disabled: Bool) -> some View {
        // TODO
        return self
    }
}
