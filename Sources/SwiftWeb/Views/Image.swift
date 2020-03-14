//
//  Image.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Image: View {
    public typealias Body = Never
    private let isResizable: Bool
    
    public var html: HTMLNode {
        .raw("not implemented")
    }
    
    let name: String

    public init(_ name: String) {
        self.name = name
        isResizable = false
    }
    
    private init(_ name: String, isResizable: Bool) {
        self.name = name
        self.isResizable = isResizable
    }

    public func resizable() -> Image {
        return Self(name, isResizable: true)
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        if !isResizable {
            return .div {
                .img(path: name)
            }
        } else {
            return .div(style: [.alignItems : .center, .justifyContent: .center]) {
                .img(path: name, style: [.width: .percent(100), .height: .percent(100)])
            }
        }
    }
}
