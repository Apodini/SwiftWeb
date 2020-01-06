//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Image: View {
    public let body: View? = nil
    public var html: HTMLNode {
        .div {
            .img(path: path)
        }
    }
    
    let path: String

    public init(name: String) {
        path = name
    }

    public func resizable() -> View {
        let newHTML: HTMLNode =
            .div {
                .img(path: path, style: [.width: .percent(100), .height: .percent(100)])
            }
        
        return ModifiedView(newHTML: newHTML)
    }
}
