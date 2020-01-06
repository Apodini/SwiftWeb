//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

public struct Image: View {
    public var body: View?
    public var html: HTMLNode {
        .div {
            .img(path: path)
        }
    }
    
    let path: String

    public init(name: String) {
        path = name
    }

    func resizable() -> View {
        let newHTML: HTMLNode =
            .div {
                .img(path: path, style: [.width: "100%", .height: "100%"])
            }
        
        return ModifiedView(newHTML: newHTML)
    }
}
