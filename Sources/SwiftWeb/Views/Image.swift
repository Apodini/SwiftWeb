//
//  Image.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Image: View {
    public typealias Body = Never
    
    public var html: HTMLNode {
        .raw("not implemented")
    }
    
    let path: String

    public init(_ name: String) {
        path = name
    }

    public func resizable() -> some View {
        let newHTML: HTMLNode =
            .div(style: [.alignItems : .center, .justifyContent: .center]) {
                .img(path: path, style: [.width: .percent(100), .height: .percent(100)])
            }
        
        return ModifiedView(body: EmptyView(), newHTML: newHTML)
    }
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .div {
            .img(path: path)
        }
    }
}
