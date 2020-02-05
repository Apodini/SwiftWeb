//
//  Sheet.swift
//  
//
//  Created by Quirin Schweigert on 04.02.20.
//

public extension View {
    func sheet<Content>(isPresented: Bool, @ViewBuilder content: () -> Content) -> some View where Content: View  {
        if !isPresented {
            return self.anyView()
        } else {
            return ZStack {
                self
                content()
            }
                .anyView()
        }
    }
}
