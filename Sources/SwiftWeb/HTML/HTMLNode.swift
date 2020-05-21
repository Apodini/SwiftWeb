//
//  HTMLNode.swift
//  
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

/**
 A structure representing an HTML element with means to modify its CSS style as well as custom attributes.
 */
public enum HTMLNode {
    case raw(String)
    
    case div(
        subNodes: [HTMLNode] = [],
        style: [CSSKey: CSSValue] = [:],
        customAttributes: [String: String?] = [:]
    )
    
    case img(
        path: String,
        style: [CSSKey: CSSValue] = [:]
    )
    
    case input(
        placeholder: String,
        value: String,
        style: [CSSKey: CSSValue] = [:],
        customAttributes: [String: String?] = [:]
    )
    
    /// Creates a string representation of the `HTMLNode`.
    public func string() -> String {
        switch self {
        case .raw(let string):
            return string
        case .div(let subNodes, let style, let customAttributes):
            return """
                <div \(Self.cssTag(from: style)) \(customAttributes.htmlAttributesString)>
                    \(subNodes.map({ $0.string()}).joined())
                </div>
                """
        case .img(let path, let style):
            return """
                <img src="/static/\(path)" \(Self.cssTag(from: style))/>
                """
        case .input(let placeholder, let value, let style, let customAttributes):
            return """
                <input placeholder="\(placeholder)" value="\(value)" \(Self.cssTag(from: style)) \(customAttributes.htmlAttributesString)/>
                """
        }
    }
    
    /// Creates a string representation of a set of CSS attributes.
    static func cssTag(from styleDictionary: [CSSKey: CSSValue]) -> String {
        guard !styleDictionary.isEmpty else {
            return .init()
        }
        
        let cssString = styleDictionary
            .compactMap { (key, value) in "\(key): \(value.cssString);" }
            .sorted()
            .joined(separator: " ")
        
        return "style=\"\(cssString)\""
    }
    
    /**
    Returns an `HTMLNode` with an added CSS style attribute.
     
     - Parameters:
         - key: The CSS key of the added attribute.
         - value: The CSS value of the added attribute.
    */
    public func withStyle(key: CSSKey, value newValue: CSSValue) -> Self {
        switch self {
        case .raw(_):
            return self
        case .div(let subnodes, let style, let customAttributes):
            var newStyle = style
            newStyle[key] = newValue
            return .div(
                subNodes: subnodes,
                style: newStyle,
                customAttributes: customAttributes
            )
            
        case .img(let path, let style):
            var newStyle = style
            newStyle[key] = newValue
            return .img(path: path, style: newStyle)
            
        case .input(let placeholder, let value, let style, let customAttributes):
            var newStyle = style
            newStyle[key] = newValue
            return .input(
                placeholder: placeholder,
                value: value,
                style: newStyle,
                customAttributes: customAttributes
            )
        }
    }
    
    /**
     Returns an `HTMLNode` with an added custom HTML attribute.
     
     - Parameters:
         - key: The `String ` key of the added attribute.
         - value: The `String ` value of the added attribute.
     */
    public func withCustomAttribute(key: String, value newValue: String? = nil) -> Self {
        switch self {
        case .div(let subnodes, let style, let customAttributes):
            var newAttributes = customAttributes
            newAttributes[key] = newValue
            
            return .div(
                subNodes: subnodes,
                style: style,
                customAttributes: newAttributes
            )
            
        case .input(let placeholder, let value, let style, let customAttributes):
            var newAttributes = customAttributes
            newAttributes[key] = newValue
            
            return .input(
                placeholder: placeholder,
                value: value,
                style: style,
                customAttributes: newAttributes
            )
            
        default:
            return self
        }
    }
    
    /// An enumeration representing a CSS key.
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
        case fontFamily = "font-family"
        case pointerEvents = "pointer-events"
        
        public var description: String {
            self.rawValue
        }
    }
    
    /// An enumeration representing a CSS value.
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
        case auto
        
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

    public static func div(style: [CSSKey: CSSValue] = [:], buildSubnode: () -> HTMLNode) -> Self {
        return .div(subNodes: [buildSubnode()], style: style)
    }
}

extension Dictionary where Key == String, Value == String? {
    var htmlAttributesString: String {
        self
            .map { key, value in
                if let value = value {
                    return "\(key)=\"\(value)\""
                }
                
                return key
            }
            .sorted()
            .joined(separator: " ")
    }
}

/// Provides functionality for an `Array` of `HTMLNode`s.
public extension Array where Element == HTMLNode {
    
    ///  Returns a single `HTMLNode` representing the array: An empty `raw` node if the array is empty, the single element of the
    ///  array or a `div` node with the elements of this array as subnodes.
    func joined() -> HTMLNode {
        if isEmpty {
            print("joining empty html")
            return .raw(.init())
        } else if count == 1, let first = first {
            return first
        } else {
            return .div(subNodes: self)
        }
    }
}
