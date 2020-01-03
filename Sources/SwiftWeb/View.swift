//
//  View.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

public protocol View {
//    associatedtype Body: View
    
    var body: View? { get }
    var html: HTMLNode { get }
}

public extension View {
    var html: HTMLNode {
        body?.html ?? .string("")
    }
}

//extension Never: View {
//    public var body: Never { fatalError("no children in Never") }
//}
//
//extension View where Body == Never {
//    public var body: Never { fatalError("no children in \(type(of: self))") }
//}
