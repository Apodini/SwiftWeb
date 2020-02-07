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
                
                VStack {
                    Spacer()
                    
                    content()
                        .frame(width: 618.0)
                        .cornerRadius(10.0)
                        .shadow(color: Color(white: 0.0).opacity(0.25), radius: 129.0, x: 0.0, y: 2.0)
                    
                    Spacer()
                }
                    .background(Color(white: 0.0).opacity(0.14))
            }
                .anyView()
        }
    }
}
