//
//  TapGestureView.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

public struct TapGestureView<Content>: View, ClickInputEventResponder where Content: View {
    public var body: Content
    public var action: () -> Void

    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes
            .joined()
    }
    
    public func onClickInputEvent() {
        action()
    }
}

public extension View {
    func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return TapGestureView(body: self, action: action)
    }
}
