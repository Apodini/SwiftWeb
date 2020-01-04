//
//  VStack.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct VStack: View {
    public var body: View? = nil
    let subviews: [View]
    
    public var html: HTMLNode {
        .div(subNodes: subviews.map(\.html), style: [
            .display: "flex",
            .flexDirection: "column",
        ])
    }
    
    public init(@VStackFunctionBuilder buildSubviews: () -> [View]) {
        subviews = buildSubviews()
    }
}

@_functionBuilder
public class VStackFunctionBuilder {
    public static func buildBlock(_ subComponents: View...) -> [View] {
        return subComponents
    }
}
