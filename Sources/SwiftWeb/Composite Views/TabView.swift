//
//  TabView.swift
//  
//
//  Created by Quirin Schweigert on 07.02.20.
//

import Foundation

public struct TabView<Content>: View where Content: View {
    let content: Content
    let selectionValue: Int
    
    public init(selection: Int = 0, @ViewBuilder content: () -> Content) {
        self.selectionValue = selection
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            tabBar
            content.map(\.self)[selectionValue].anyView()
        }
    }
    
    var tabBar: some View {
        VStack() {
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
                            .foregroundColor(Color(white: 0.58))
                        image
                            .resizable()
                            .frame(width: 22.0, height: 22.0)
                    }
                    
                    return index == self.selectionValue ?
                        stack.systemBlueFilter().anyView()
                        : stack.systemGrayFilter().anyView()
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
