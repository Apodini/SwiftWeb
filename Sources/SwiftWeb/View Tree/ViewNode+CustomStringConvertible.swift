//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 31.03.20.
//

import Foundation

extension ViewNode: CustomStringConvertible {
    public var description: String {
        var descriptionOfThisNode = "\(Self.simpleType(of: view)) \(stateStorageNode.state)"
        
        if let text = view as? Text {
            descriptionOfThisNode.append(" \"\(text.text)\"")
        }
        
        descriptionOfThisNode.append(" \(stateStorageNode.viewInstanceID.uuidString)")
        
        if subnodes.isEmpty {
            return "<ViewNode: \(descriptionOfThisNode)/>"
        } else {
            return """
            <ViewNode: \(descriptionOfThisNode)>
            \(subnodes.map({ $0.description }).joined(separator: "\n").blockIndented())
            </ViewNode>
            """
        }
    }
    
    static func simpleType(of value: Any) -> String {
        let typeString = String(describing: type(of: value))
        if let simpleTypeString = typeString.split(separator: "<").first {
            return String(simpleTypeString)
        } else {
            return typeString
        }
    }
}

extension String {
    func blockIndented() -> String {
        return self
            .split(separator: "\n")
            .map {
                "   \($0)"
        }
        .joined(separator: "\n")
    }
}
