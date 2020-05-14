//
//  GlobalOverlayView.swift
//  
//
//  Created by Quirin Schweigert on 16.03.20.
//

import Foundation

struct GlobalOverlayView<FixedContent, OverlayContent>: View
where FixedContent: View, OverlayContent: View {
    let fixedContent: FixedContent
    let overlayContent: OverlayContent
    
    public var body: some View {
        TupleView((
            fixedContent,
            ModifiedContent(content: overlayContent, modifier: HTMLTransformingViewModifier() { html in
                html
                    .withStyle(key: .position, value: .fixed)
                    .withStyle(key: .top, value: .zero)
                    .withStyle(key: .right, value: .zero)
                    .withStyle(key: .bottom, value: .zero)
                    .withStyle(key: .left, value: .zero)
            })
                .frame(width: 0, height: 0) // to stop growing axes from the overlay from propagating
        ))
    }
}

public extension View {
    func globalOverlay<Overlay>(@ViewBuilder _ overlay: () -> Overlay) -> some View where Overlay: View {
        return GlobalOverlayView(fixedContent: self, overlayContent: overlay())
    }
}
