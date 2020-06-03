//
//  TapGestureView.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

struct TapGestureView<Content>: View, ClickInputEventResponder where Content: View {
    var body: Content
    var action: () -> Void

    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes
            .joined()
    }
    
    func onClickInputEvent() {
        action()
    }
}

public extension View {
    func onTapGesture(perform action: @escaping () -> Void) -> some View {
        TapGestureView(body: self, action: action)
    }
}
