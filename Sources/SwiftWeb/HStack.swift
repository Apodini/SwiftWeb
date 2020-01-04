//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct HStack: View {
    public var body: View? = nil
    let subviews: [View]
    
    public var html: HTMLNode {
        .div(subNodes: subviews.map(\.html), style: [
            .display: "flex",
            .flexDirection: "row",
        ])
    }
    
    public init(@HStackFunctionBuilder buildSubviews: () -> [View]) {
        subviews = buildSubviews()
    }
}

@_functionBuilder
public class HStackFunctionBuilder {
    public static func buildBlock(_ subComponents: View...) -> [View] {
        return subComponents
    }
}
