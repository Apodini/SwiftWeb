//
//  TapGestureView.swift
//  
//
//  Created by Quirin Schweigert on 04.03.20.
//

import Foundation

public protocol TypeErasedTapGestureView {
    var tapGestureViewID: String { get }
    var action: () -> Void { get }
}

public struct TapGestureView<Content>: TypeErasedTapGestureView, View
where Content: View {
    public var body: Content
    public var action: () -> Void
    @State public var tapGestureViewID = UUID().uuidString

    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes.joined().withCustomAttribute(
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
