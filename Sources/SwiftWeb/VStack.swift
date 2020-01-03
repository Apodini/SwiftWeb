//
//  VStack.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public class VStack: View {
    public var body: View? = nil
    public let html: HTMLNode
    let subviews: [View]
    
    public init(@VStackFunctionBuilder buildSubviews: () -> [View]) {
        subviews = buildSubviews()
        html = .div(subNodes: subviews.map(\.html), style: [:])
    }
}

@_functionBuilder
public class VStackFunctionBuilder {
    public static func buildBlock(_ subComponents: View...) -> [View] {
        return subComponents
    }
}
