//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Spacer: View {
    public let body: View? = nil
    public let html: HTMLNode

    public init() {
        html = .div(style: [.flexGrow: .one])
    }
}
