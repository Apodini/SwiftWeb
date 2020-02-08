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
    
    static func generateCSSTag(from styleDictionary: [CSSKey: CSSValue],
                               forLayoutInAxis layoutAxis: LayoutAxis? = nil) -> String? {
        guard !styleDictionary.isEmpty else {
            return nil
        }
        
        let cssString = styleDictionary
            .compactMap { (key, value) in "\(key): \(value.cssString); " }
            .joined()
        
        return "style=\"\(cssString)\""
    }
    
    func withAddedStyle(key: CSSKey, value: CSSValue) -> HTMLNode {
        switch self {
        case .raw(_):
            return self
        case .div(let subnodes, let style):
            var newStyle = style
            newStyle[key] = value
            return .div(subNodes: subnodes, style: newStyle)
        case .img(let path, let style):
            var newStyle = style
            newStyle[key] = value
            return .img(path: path, style: newStyle)
        }
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
        case marginLeft = "margin-left"
        case position
        case borderRadius = "border-radius"
        case boxShadow = "box-shadow"
        case padding
        case paddingLeft = "padding-left"
        case paddingTop = "padding-top"
        case paddingRight = "padding-right"
        case paddingBottom = "padding-bottom"
        case border
        case overflow
        case minWidth = "min-width"
        case minHeight = "min-height"
        case filter
        case top
        case left
        case right
        case bottom
        
        public var description: String {
            self.rawValue
        }
    }
    
    public enum CSSValue: Equatable {
        case raw(String)
        case px(Double)
        case flex
        case row
        case column
        case center
        case flexStart
        case flexEnd
        case stretch
        case int(Int)
        case zero
        case one
        case percent(Int)
        case color(Color)
        case initial
        case relative
        case absolute
        case shadow(offsetX: Double, offsetY: Double, radius: Double, color: Color)
        case border(width: Double, color: Color)
        case hidden
        case fixed
        
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
            case .flexStart:
                return "flex-start"
            case .flexEnd:
                return "flex-end"
            case .shadow(let offsetX, let offsetY, let radius, let color):
                return "\(offsetX)px \(offsetY)px \(radius)px \(color.cssString)"
            case .border(let width, let color):
                return "\(width)px solid \(color.cssString)"
            default:
                return String(describing: self)
            }
        }
        
        public static func == (lhs: HTMLNode.CSSValue, rhs: HTMLNode.CSSValue) -> Bool {
            return lhs.cssString == rhs.cssString
        }
    }

    static func div(style: [CSSKey: CSSValue] = [:], buildSubnode: () -> HTMLNode) -> Self {
        return .div(subNodes: [buildSubnode()], style: style)
    }
}
