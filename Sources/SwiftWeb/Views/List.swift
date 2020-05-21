//
//  List.swift
//  
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

/// A container that presents rows of data arranged in a single column.
public struct List<Content>: View, GrowingAxesModifying where Content: View {
    var content: Content

    /// Creates a list with the given content.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    /// Creates a list that identifies its rows based on a key path to the identifier of the underlying data.
    public init<Data, ID, RowContent>(_ data: Data,
                                      id: KeyPath<Data.Element, ID>,
                                      rowContent: @escaping (Data.Element) -> RowContent)
        where Content == ForEach<Data, ID, HStack<RowContent>>,
              Data : RandomAccessCollection,
              ID : Hashable, RowContent : View {
        
        content = ForEach(data, id: id) { element in
            HStack(alignment: .center) {
                rowContent(element)
            }
        }
    }
    
    public var body: some View {
        content
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        let separator: HTMLNode = .div(style: [
            .height: .px(1),
            .backgroundColor: .color(Color(white: 0.85)),
            .width: .percent(100),
        ])
        
        var subnodesWithSeparators: [HTMLNode] = []

        htmlOfSubnodes.forEach { cell in
            subnodesWithSeparators.append(cell)
            subnodesWithSeparators.append(separator)
        }
        
        return .div(style: [
            .paddingLeft: .px(64),
            .display: .flex,
            .flexDirection: .column,
            .alignItems: .stretch,
        ]) {
            .div(subNodes: subnodesWithSeparators, style: [
                .display: .flex,
                .flexDirection: .column,
                .alignItems: .flexStart,
                .justifyContent: .center,
            ])
        }
    }

    public func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>) -> Set<GrowingLayoutAxis> {
        [.horizontal]
    }
}
