//
//  List.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct List: View {
    public typealias Body = Never
    
    public var cells: [HTMLNode] = []
    
    public var growingLayoutAxes: Set<GrowingLayoutAxis> {
        [.horizontal]
    }

    public var html: HTMLNode {
        let separator: HTMLNode = .div(style: [
            .height: .px(1),
            .backgroundColor: .color(Color(white: 0.85)),
            .width: .percent(100),
        ])

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
                .justifyContent: .center,
            ])
        }
    }

    public init<Content>(@ViewBuilder buildSubviews: () -> Content) where Content: View {
        let body = buildSubviews()
        cells = Self.buildSubnodes(fromView: body)
    }

    public init<Data>(_ data: Data, buildSubview: (Data.Element) -> TypeErasedView) where Data: RandomAccessCollection {
        cells = data.map(buildSubview).map(\.html)
    }
}
