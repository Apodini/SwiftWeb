//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

public struct Frame<Content>: View, GrowingAxesModifying where Content: View {
    public let body: Content
    
    let width: Double?
    let height: Double?
    let minWidth: Double?
    let minHeight: Double?
    
    public var html: HTMLNode {
        .div(
            subNodes: [
                body.html
                    .withAddedStyle(key: .flexGrow, value: .one)
                    .withAddedStyle(key: .alignSelf, value: .stretch)
            ],
            style: [
                .width : width != nil ? .px(width!) : .initial,
                .height : height != nil ? .px(height!) : .initial,
                .minWidth : minWidth != nil ? .px(minWidth!) : .initial,
                .minHeight : minHeight != nil ? .px(minHeight!) : .initial,
            ]
        )
    }
    
    // Fixing the width and / or height of a View removes its possibility to grow in the respective axis.
    public var modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> {
        Set<GrowingLayoutAxis>(body.growingLayoutAxes.compactMap { axis in
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

    public init(framedView: Content,
                width: Double? = nil,
                height: Double? = nil,
                minWidth: Double? = nil,
                minHeight: Double? = nil) {
        body = framedView
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
    }
}

public extension View {
    func frame(width: Double? = nil,
               height: Double? = nil,
               minWidth: Double? = nil,
               minHeight: Double? = nil) -> some View {
        return Frame(framedView: self, width: width, height: height, minWidth: minWidth, minHeight: minHeight)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
