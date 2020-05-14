//
//  Section.swift
//  
//
//  Created by Quirin Schweigert on 28.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

public struct Section<Parent, Content>: View where Parent: View, Content: View {
    let header: Parent
    let content: Content
    
    public init(header: Parent, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            header
                .font(.system(size: 14))
                .foregroundColor(Color(red:0.43, green:0.43, blue:0.45))
                .padding(.leading, 31)
                .padding(.top, 23)
                .padding(.bottom, 6)
            
            Color(white: 0.83)
                .frame(height: 0.5)
            
            content
                .padding(.horizontal, 31)
                .background(Color(white: 1.0))
            
            Color(white: 0.83)
                .frame(height: 0.5)
        }
    }
}
