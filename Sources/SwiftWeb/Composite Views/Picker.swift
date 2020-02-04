//
//  Picker.swift
//  SwiftWebServer
//
//  Created by Quirin Schweigert on 29.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

public struct Picker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View  {
    let content: Content
    let selectionValue: SelectionValue
    
    public init<S>(_ title: S, selection: SelectionValue, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.content = content()
        self.selectionValue = selection
    }
    
    public var body: some View {
        HStack {
            ForEach(content.map(\.self)) { view -> AnyView in
                if let taggedView = view as? TaggedViewProtocol,
                   let tag = taggedView.tag as? SelectionValue,
                   tag == self.selectionValue {
                    return view.anyView()
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 37)
                        .padding(.vertical, 5)
                        .background(Color(white: 1.0))
                        .cornerRadius(6)
                        .shadow(color: Color.init(white: 0).opacity(0.24), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 3)
                        .anyView()
                } else {
                    return view.anyView()
                        .font(.system(size: 14))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                        .anyView()
                }
            }
        }
        .background(Color(white: 0.93))
        .cornerRadius(8)
    }
}
