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
