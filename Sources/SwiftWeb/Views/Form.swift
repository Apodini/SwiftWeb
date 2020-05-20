//
//  Form.swift
//  
//
//  Created by Quirin Schweigert on 28.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

/// A container for grouping controls used for data entry, such as in settings or inspectors.
public struct Form<Content>: View where Content: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            content
        }
            .padding(.bottom, 20)
            .background(Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0))
    }
}
