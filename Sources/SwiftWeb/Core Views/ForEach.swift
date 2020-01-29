//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 29.01.20.
//

import Foundation

public struct ForEach<Data, ID, Content>: View, CustomMappable where Data : RandomAccessCollection, ID : Hashable, Content: View {
    let data: Data
    let idKeyPath: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, id idKeyPath: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.idKeyPath = idKeyPath
        self.content = content
    }
    
    public func customMap<T>(_ transform: (TypeErasedView) -> T) -> [T] {
        return data.map(content).map(transform)
    }
}

extension ForEach where Data.Element == ID {
    public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.self, content: content)
    }
}
