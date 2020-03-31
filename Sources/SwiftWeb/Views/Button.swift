//
//  Button.swift
//  
//
//  Created by Quirin Schweigert on 17.03.20.
//

import Foundation

public struct Button<Label>: View where Label : View {
    let action: () -> Void
    let label: Label
    
    public var body: some View {
        label
            .font(.system(size: 34, weight: .thin))
            .systemBlueFilter()
            .onTapGesture(perform: action)
    }
    
    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
}

public extension Button where Label == Text {
    init<S>(_ title: S, action: @escaping () -> Void) where S : StringProtocol {
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
