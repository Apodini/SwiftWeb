//
//  Picker.swift
//  
//
//  Created by Quirin Schweigert on 29.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

public struct Picker<SelectionValue, Content>: View
        where SelectionValue: Hashable, Content: View  {
    let content: Content
    var selectionValue: Binding<SelectionValue>
    
    public init<S>(_ title: S,
            selection: Binding<SelectionValue>,
            @ViewBuilder content: () -> Content) where S: StringProtocol {
        selectionValue = selection
        self.content = content()
    }
    
    public var body: some View {
        HStack {
            ForEach(content.map(\.self)) { view -> AnyView in
                var wrappedView: AnyView
                
                if let taggedView = view as? TypeErasedTaggedView,
                   let tag = taggedView.tag as? SelectionValue,
                    tag == self.selectionValue.wrappedValue {
                    wrappedView = view.anyView()
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 37)
                        .padding(.vertical, 5)
                        .background(Color(white: 1.0))
                        .cornerRadius(6)
                        .shadow(color: Color(white: 0).opacity(0.24),
                                radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 3)
                        .anyView()
                } else {
                    wrappedView = view.anyView()
                        .font(.system(size: 14))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                        .anyView()
                }

                // add tap gesture listeners to select the respective values
                if let taggedView = view as? TypeErasedTaggedView,
                    let tag = taggedView.tag as? SelectionValue {
                    wrappedView = wrappedView
                        .onTapGesture {
                            self.selectionValue.wrappedValue = tag
                        }
                        .anyView()
                }
                
                return wrappedView
            }
        }
        .background(Color(white: 0.93))
        .cornerRadius(8)
    }
}
