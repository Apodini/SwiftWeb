//
//  ModifiedView.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct ModifiedView<Body>: View where Body: View {
    public var body: Body
    
    public var html: HTMLNode
    
    init(body: Body, newHTML: HTMLNode) {
        self.body = body
        html = newHTML
    }
}
