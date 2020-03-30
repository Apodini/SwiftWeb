//
//  TextField.swift
//  
//
//  Created by Quirin Schweigert on 29.03.20.
//

import Foundation

public struct TextField: View {
    public typealias Body = Never
    
    let title: String
    
    
    public func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .input(placeholder: title, style: [.pointerEvents: .auto])
    }
    
    public init<S>(_ title: S) where S: StringProtocol {
        self.title = String(title)
    }
}
