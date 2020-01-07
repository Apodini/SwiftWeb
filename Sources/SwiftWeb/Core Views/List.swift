//
//  List.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct List: View {
    public var body: View? = nil
    var subviews: [View]
    
    public var html: HTMLNode {
        let separator: HTMLNode = .div(style: [
            .height: .px(1),
            .backgroundColor: .color(Color(white: 0.85)),
            .width: .percent(100)
        ])
        
        let cells = subviews.map(\.html)
        var subNodes: [HTMLNode] = []
        
        cells.forEach { cell in
            subNodes.append(cell)
            subNodes.append(separator)
        }

        
        return .div(style: [
                    .paddingLeft: .px(64),
                    .display: .flex,
                    .flexDirection: .column,
                    .alignItems: .stretch,
                ]) {
            .div(subNodes: subNodes, style: [
                .display: .flex,
                .flexDirection: .column,
                .alignItems: .flexStart,
            ])
        }
    }
    
    public init(@ListFunctionBuilder buildSubviews: () -> [View]) {
        subviews = buildSubviews()
    }
    
    public init<Data>(_ data: Data, buildSubview: (Data.Element) -> View) where Data: RandomAccessCollection {
        subviews = data.map(buildSubview)
    }
}

@_functionBuilder
class ListFunctionBuilder {
    static func buildBlock(_ subComponents: View...) -> [View] {
        return subComponents
    }
}
