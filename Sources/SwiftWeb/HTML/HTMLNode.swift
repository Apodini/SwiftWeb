//
//  HTMLNode.swift
//  App
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

public enum HTMLNode {
    case raw(String)
    case div(subNodes: [HTMLNode] = [], style: [CSSKey: CSSValue] = [:])
    case img(path: String, style: [CSSKey: CSSValue] = [:])
    
    public func render() -> String {
        switch self {
        case .raw(let string):
            return string
        case .div(let subNodes, let style):
            return """
                <div \(Self.generateCSSTag(from: style) ?? "")>
                    \(subNodes.map({ $0.render()}).joined())
                </div>
            """
        case .img(let path, let style):
            return """
                <img src="/\(path)" \(Self.generateCSSTag(from: style) ?? "")/>
            """
        }
    }
    
    static func generateCSSTag(from styleDictionary: [CSSKey: CSSValue]) -> String? {
        guard !styleDictionary.isEmpty else {
            return nil
        }
        
        let cssString = styleDictionary
            .compactMap { (key, value) in "\(key): \(value.cssString); " }
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
        case color
        case justifyContent = "justify-content"
        case alignItems = "align-items"
        case fontSize = "font-size"
        case fontWeight = "font-weight"
        case flexBasis = "flex-basis"
        case flexShrink = "flex-shrink"
        case alignSelf = "align-self"
        
        public var description: String {
            self.rawValue
        }
    }
    
    public enum CSSValue {
        case raw(String)
        case px(Double)
        case flex
        case row
        case column
        case center
        case stretch
        case int(Int)
        case zero
        case one
        case percent(Int)
        case color(Color)
        case initial
        
        public var cssString: String {
            switch self {
            case .raw(let string):
                return string
            case .px(let value):
                return "\(value)px"
            case .int(let value):
                return String(describing: value)
            case .zero:
                return "0"
            case .one:
                return "1"
            case .percent(let value):
                return "\(value)%"
            case .color(let color):
                return color.cssString
            default:
                return String(describing: self)
            }
        }
    }

    
    // doesn't seem to work
//    static func div(style: [CSSKey: String], @HTMLNodeFunctionBuilder buildSubnodes: () -> [HTMLNode]) -> Self {
//        return .div(subNodes: buildSubnodes(), style: style)
//    }
    
    static func div(style: [CSSKey: CSSValue] = [:], buildSubnode: () -> HTMLNode) -> Self {
        return .div(subNodes: [buildSubnode()], style: style)
    }
    
    func shouldGrow(inAxis axis: LayoutAxis) -> Bool {
        return false
    }
}

@_functionBuilder
class HTMLNodeFunctionBuilder {
    public static func buildBlock(_ subComponents: HTMLNode...) -> [HTMLNode] {
        return subComponents
    }
    
    static func buildExpression(_ expression: HTMLNode) -> [HTMLNode] {
      return [expression]
    }
}
