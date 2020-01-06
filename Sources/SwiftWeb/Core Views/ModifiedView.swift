//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

struct ModifiedView: View {
    let body: View? = nil
    var html: HTMLNode
    
    init(newHTML: HTMLNode) {
        html = newHTML
    }
}
