//
//  HTMLNode.swift
//  App
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

public enum HTMLNode {
    case string(String)
    case div(subNodes: [HTMLNode], style: [String: String])
    case img(name: String, style: [String: String])
    
    public func render() -> String {
        switch self {
        case .string(let string):
            return string
        case .div(let subNodes, let style):
            return """
                <div style="\(Self.generateCSS(from: style))">
                    \(subNodes.map({ $0.render()}).joined())
                </div>
            """
        case .img(let name, let style):
            return """
                <img src="/\(name)" style="\(Self.generateCSS(from: style))"/>
            """
        }
    }
    
    static func generateCSS(from styleDictionary: [String: String]) -> String {
        return styleDictionary
            .compactMap { (key, value) in "\(key): \(value); " }
            .joined()
    }
}
