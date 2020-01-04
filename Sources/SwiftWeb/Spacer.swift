//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Spacer: View {
    public var body: View? = nil
    public var html: HTMLNode

    public init() {
        html = .div(subNodes: [], style: [.flexGrow: "1"])
    }
}
