//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

protocol Stack: View {
    var subviews: [View] { get }
}

extension Stack {
    public var body: View? {
        nil
    }
    
    static func insertSpacers(forSpacing spacing: Double?,
                              in subviews: [View],
                              horizontally: Bool = false) -> [View] {
        guard let spacing = spacing else {
            return subviews
        }
        
        var spacedViews: [View] = []
        
        for view in subviews {
            if !spacedViews.isEmpty {
                if horizontally {
                    spacedViews.append(Frame(width: spacing))
                } else {
                    spacedViews.append(Frame(height: spacing))
                }
            }
            
            spacedViews.append(view)
        }
        
        return spacedViews
    }
}

@_functionBuilder
public class StackFunctionBuilder {
    public static func buildBlock(_ subComponents: View...) -> [View] {
        return subComponents
    }
    
    static func buildExpression(_ expression: View) -> [View] {
      return [expression]
    }
}
