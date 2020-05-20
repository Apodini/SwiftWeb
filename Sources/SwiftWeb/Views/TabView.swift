//
//  TabView.swift
//  
//
//  Created by Quirin Schweigert on 07.02.20.
//

import Foundation

/// A view that switches between multiple child views using interactive user interface elements.
public struct TabView<Content>: View where Content: View {
    let content: Content
    @State var selectionValue: Int = 0
    
    public init(selection: Int = 0, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.selectionValue = selection
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            tabBar
            content.map(\.self)[selectionValue].anyView()
        }
    }
    
    var tabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 136.0) {
                Spacer()

                ForEach(Array(content.map(\.self).enumerated())) {
                    (index, tab) -> AnyView in
                    
                    let tabItem = tab as? TypeErasedTabItem
                    
                    let text = tabItem?.text ?? Text(String(describing: index))
                    let image = tabItem?.image ?? Image("placeholder.png")
                    
                    let stack = VStack(spacing: 7) {
                        text
                            .font(.system(size: 11, weight: .medium))
                        image
                            .resizable()
                            .frame(width: 22.0, height: 22.0)
                    }
                    
                    let tabItemView = index == self.selectionValue ?
                        stack.systemBlueFilter().anyView()
                        : stack.systemGrayFilter().anyView()
                    
                    return tabItemView.onTapGesture {
                        self.selectionValue = index
                    }.anyView()
                }
                
                Spacer()
            }
            .frame(height: 73.0)
            
            Color(white: 0.77)
                .frame(height: 0.5)
        }
        .background(Color(white: 0.97))
    }
}
