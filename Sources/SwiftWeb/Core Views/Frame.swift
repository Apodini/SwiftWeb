//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Frame<Content>: View where Content: View {
    public let body: Content
    
    let width: Double?
    let height: Double?
    
    public var html: HTMLNode {
        .div(
            subNodes: [
                body.html
                    .withAddedStyle(key: .width, value: .percent(100))
                    .withAddedStyle(key: .height, value: .percent(100))
            ],
            style: [
                .width : width != nil ? .px(width!) : .initial,
                .height : height != nil ? .px(height!) : .initial,
            ]
        )
    }
    
    // Fixing the width and / or height of a View removes its possibility to grow in the respective axis.
    public var layoutGrowthAxes: Set<LayoutGrowthAxis> {
        Set<LayoutGrowthAxis>(body.layoutGrowthAxes.compactMap { axis in
            switch (axis: axis, width: width, height: height) {
            case (axis: .horizontal, width: .some(_), height: _):
                return nil
            case (axis: .vertical, width: _, height: .some(_)):
                return nil
            case (axis: .undetermined, width: .some(_), height: _):
                return .vertical
            case (axis: .undetermined, width: _, height: .some(_)):
                return .vertical
            default:
                return axis
            }
        })
    }

    init(framedView: Content, width: Double? = nil, height: Double? = nil) {
        body = framedView
        self.width = width
        self.height = height
    }
}

public extension View {
    func frame(width: Double? = nil, height: Double? = nil) -> some View {
        return Frame(framedView: self, width: width, height: height)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
