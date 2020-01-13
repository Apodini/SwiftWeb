//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Frame<Content>: View where Content: View {
    public typealias Body = Never

    public var html: HTMLNode
    
    init(framedView: Content, width: Double? = nil, height: Double? = nil) {
        html = .div(subNodes: [framedView.html], style: [
            .width : width != nil ? .px(width!) : .initial,
            .height : height != nil ? .px(height!) : .initial,
            .flexGrow: .zero
        ])
    }
}

public extension View {
    func frame(width: Double? = nil, height: Double? = nil) -> some View {
        
        // todo: make frame inherit grow properties!

        return Frame(framedView: self, width: width, height: height)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
