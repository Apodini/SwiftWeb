//
//  AnyView.swift
//  
//
//  Created by Quirin Schweigert on 30.01.20.
//

import Foundation

public struct AnyView: View, GrowingAxesModifying {
    
    public typealias Body = Never
    
    public let html: HTMLNode
    
    public let modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis>
    
    init(html: HTMLNode, modifiedGrowingLayoutAxes: Set<GrowingLayoutAxis> = []) {
        self.html = html
        self.modifiedGrowingLayoutAxes = modifiedGrowingLayoutAxes
    }
    
    init<Content>(content: Content) where Content: View {
        self.init(html: content.html, modifiedGrowingLayoutAxes: content.growingLayoutAxes)
    }
}

public extension TypeErasedView {
    func anyView() -> AnyView {
        return AnyView(html: html, modifiedGrowingLayoutAxes: growingLayoutAxes)
    }
}
