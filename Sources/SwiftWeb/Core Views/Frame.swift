//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Frame: View {
    public let body: View? = nil
    public var html: HTMLNode
    
    init(framedView: View? = nil, width: Double? = nil, height: Double? = nil) {
        var subNodes: [HTMLNode] = []
            
        if let framedView = framedView {
            subNodes = [framedView.html]
        }
        
        html = .div(subNodes: subNodes, style: [
            .width : width != nil ? .px(width!) : .initial,
            .height : height != nil ? .px(height!) : .initial,
            .flexGrow: .zero
        ])
    }
}

public extension View {
    func frame(width: Double? = nil, height: Double? = nil) -> View {
        
        // todo: make frame inherit grow properties!

        return Frame(framedView: self, width: width, height: height)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
