//
//  Stack.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public protocol Stack: View {
    var subnodes: [HTMLNode] { get }
}

extension Stack {
    static func insertSpacers(forSpacing spacing: Double?,
                              inNodes nodes: [HTMLNode],
                              axis: LayoutAxis) -> [HTMLNode] {
        guard let spacing = spacing else {
            return nodes
        }

        var spacedNodes: [HTMLNode] = []

        for view in nodes {
            if !spacedNodes.isEmpty {
                switch axis {
                case .horizontal:
                    spacedNodes.append(.div(subNodes: [], style: [.width : .px(spacing)]))
                case .vertical:
                    spacedNodes.append(.div(subNodes: [], style: [.height : .px(spacing)]))
                }
            }

            spacedNodes.append(view)
        }

        return spacedNodes
    }
}
