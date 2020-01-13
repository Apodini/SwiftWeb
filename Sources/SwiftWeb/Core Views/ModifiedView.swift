//
//  ModifiedView.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct ModifiedView: View {
    public typealias Body = Never
    
    public var html: HTMLNode
    
    init(newHTML: HTMLNode) {
        html = newHTML
    }
}
