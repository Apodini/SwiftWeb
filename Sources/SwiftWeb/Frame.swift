//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Frame: View {
    public var body: View? = nil
    public var html: HTMLNode
    
    init(framedView: View, width: Double? = nil, height: Double? = nil) {
        html = .div(subNodes: [framedView.html], style: [
            .width : width?.cssPixelValue ?? "initial",
            .height : height?.cssPixelValue ?? "initial",
            .flexGrow: "0"
        ])
    }
}

public extension View {
    func frame(width: Double? = nil, height: Double? = nil) -> View {
        return Frame(framedView: self, width: width, height: height)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
