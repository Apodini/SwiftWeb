//
//  Sheet.swift
//  
//
//  Created by Quirin Schweigert on 04.02.20.
//

struct Sheet<StaticContent, ModalContent>: View
where StaticContent: View, ModalContent: View {
    let staticContent: StaticContent
    let modalContent: ModalContent
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if !isPresented {
            return staticContent.anyView()
        } else {
            return staticContent.globalOverlay {
                ZStack {
                    Color(white: 0.0).opacity(0.14).onTapGesture {
                        self.isPresented = false
                    }

                    HStack {
                        Spacer()

                        VStack {
                            Spacer()

                            modalContent
                                .frame(width: 618.0)
                                .cornerRadius(10.0)
                                .shadow(color: Color(white: 0.0).opacity(0.25),
                                        radius: 129.0,
                                        x: 0.0,
                                        y: 2.0)
                                .onTapGesture { }

                            Spacer()
                        }

                        Spacer()
                    }
                }
            }
            .anyView()
        }
    }
}

public extension View {
    func sheet<Content>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View where Content: View {
        Sheet(staticContent: self, modalContent: content(), isPresented: isPresented)
    }
}
