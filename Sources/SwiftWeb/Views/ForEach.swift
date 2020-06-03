//
//  ForEach.swift
//  
//
//  Created by Quirin Schweigert on 29.01.20.
//

import Foundation

/// The collection of underlying identified data that SwiftWeb uses to create views dynamically.
public struct ForEach<Data, ID, Content>: View, CustomMappable
where Data: RandomAccessCollection, Content: View {
    let data: Data
    let idKeyPath: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        htmlOfSubnodes.joined()
    }
    
    /// Creates an instance that uniquely identifies and creates views across updates based on the provided key path to the underlying
    /// data’s identifier.
    public init(_ data: Data, id idKeyPath: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.idKeyPath = idKeyPath
        self.content = content
    }
    
    public func customMap<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        data.map(content).map(transform)
    }
}

extension ForEach where Data.Element == ID {
    /// Creates an instance that uniquely identifies and creates views across updates based on the identity of the underlying data.
    public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.self, content: content)
    }
}
