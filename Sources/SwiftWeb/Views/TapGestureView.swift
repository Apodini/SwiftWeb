//
//  TapGestureView.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

protocol TypeErasedTapGestureView {
    var tapGestureViewID: String { get }
    var action: () -> Void { get }
}

public struct TapGestureView<Content>: TypeErasedTapGestureView, View
where Content: View {
    public var body: Content
    var tapGestureViewID = "0000" // UUID()
    var action: () -> Void
    
    public var html: HTMLNode {
        body.html.withCustomAttribute(
            key: "tap-id",
            value: tapGestureViewID
        )
    }
}

public extension View {
    func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return TapGestureView(body: self, action: action)
    }
}
