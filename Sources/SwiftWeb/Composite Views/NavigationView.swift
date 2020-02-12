//
//  NavigationView.swift
//  
//
//  Created by Quirin Schweigert on 08.02.20.
//

import Foundation

public struct NavigationView<Content>: View where Content: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Create Transaction")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            .frame(height: 50)
            .background(Color(red:0.98, green:0.98, blue:0.99))
            
            Color(white: 0.73)
                .frame(height: 0.5)
            
            content
        }
    }
}
