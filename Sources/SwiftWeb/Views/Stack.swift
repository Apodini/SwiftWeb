//
//  Stack.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

protocol Stack: View { }

extension Stack {
    static func insertSpacers(forSpacing spacing: Double?,
                              inNodes nodes: [HTMLNode],
                              axis: LayoutAxis) -> [HTMLNode] {
        let spacing = spacing ?? 8

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
