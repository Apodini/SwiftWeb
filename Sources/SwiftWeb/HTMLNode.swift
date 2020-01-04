//
//  HTMLNode.swift
//  App
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

public enum HTMLNode {
    case string(String)
    case div(subNodes: [HTMLNode], style: [CSSKey: String])
    case img(name: String, style: [CSSKey: String])
    
    public func render() -> String {
        switch self {
        case .string(let string):
            return string
        case .div(let subNodes, let style):
            return """
                <div \(Self.generateCSSTag(from: style) ?? "")>
                    \(subNodes.map({ $0.render()}).joined())
                </div>
            """
        case .img(let name, let style):
            return """
                <img src="/\(name)" \(Self.generateCSSTag(from: style) ?? "")/>
            """
        }
    }
    
    static func generateCSSTag(from styleDictionary: [CSSKey: String]) -> String? {
        guard !styleDictionary.isEmpty else {
            return nil
        }
        
        let cssString = styleDictionary
            .compactMap { (key, value) in "\(key): \(value); " }
            .joined()
        
        return "style=\"\(cssString)\""
    }
    
    public enum CSSKey: String, CustomStringConvertible {
        case backgroundColor = "background-color"
        case flexGrow = "flex-grow"
        case display
        case flexDirection = "flex-direction"
        case width
        case height
        
        public var description: String {
            self.rawValue
        }
    }
}
