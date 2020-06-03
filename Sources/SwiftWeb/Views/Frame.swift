//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 04.01.20.
//

import Foundation

struct Frame<Content>: View, GrowingAxesModifying where Content: View {
    let body: Content
    
    let width: Double?
    let height: Double?
    let minWidth: Double?
    let minHeight: Double?

    // swiftlint:disable force_unwrapping
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        .div(
            subNodes: [
                htmlOfSubnodes.joined()
                    .withStyle(key: .flexGrow, value: .one)
                    .withStyle(key: .alignSelf, value: .stretch)
            ],
            style: [
                .width: width != nil ? .px(width!) : .initial,
                .height: height != nil ? .px(height!) : .initial,
                .minWidth: minWidth != nil ? .px(minWidth!) : .initial,
                .minHeight: minHeight != nil ? .px(minHeight!) : .initial
            ]
        )
    }
    // swiftlint:enable force_unwrapping
    
    // Fixing the width and / or height of a View removes its possibility to grow in the respective
    // axis.
    func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes growingAxesOfSubnodes: Set<GrowingLayoutAxis>) -> Set<GrowingLayoutAxis> {
        Set<GrowingLayoutAxis>(growingAxesOfSubnodes.compactMap { axis in
            switch (axis: axis, width: width, height: height) {
            case (axis: .horizontal, width: .some, height: _):
                return nil
            case (axis: .vertical, width: _, height: .some):
                return nil
            case (axis: .undetermined, width: .some, height: _):
                return .vertical
            case (axis: .undetermined, width: _, height: .some):
                return .vertical
            default:
                return axis
            }
        })
    }

    init(framedView: Content,
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
        Frame(framedView: self, width: width, height: height, minWidth: minWidth, minHeight: minHeight)
    }
}

extension Double {
    var cssPixelValue: String {
        "\(description)px"
    }
}
