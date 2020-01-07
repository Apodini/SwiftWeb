//
//  View.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public protocol View {
//    associatedtype Body: View
    
    var body: View? { get }
    var html: HTMLNode { get }    
}

public extension View {
    var html: HTMLNode {
        body?.html ?? .raw("")
    }
}

public extension View {
    func cornerRadius(_ radius: Double) -> ModifiedView {
        return ModifiedView(newHTML: html.withAddedStyle(key: .borderRadius, value: .px(radius)) ?? html)
    }
    
    func shadow(color: Color, radius: Double, x: Double, y: Double) -> ModifiedView {
        return ModifiedView(newHTML:
            html.withAddedStyle(key: .boxShadow,
                                value: .shadow(offsetX: x,
                                               offsetY: y,
                                               radius: radius,
                                               color: color)) ?? html
        )
    }
}
