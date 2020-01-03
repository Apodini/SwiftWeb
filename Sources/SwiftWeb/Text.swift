//
//  Text.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public struct Text: View {
    public var body: View? = nil
    public let html: HTMLNode
    
    let text: String
    
    public init(_ text: String) {
        self.text = text
        self.html = .string(text)
    }
}
