//
//  TabItem.swift
//  
//
//  Created by Quirin Schweigert on 08.02.20.
//

protocol TypeErasedTabItem {
    var image: Image? { get }
    var text: Text? { get }
}

struct TabItem<Body>: View, TypeErasedTabItem where Body: View {
    let image: Image?
    let text: Text?
    let body: Body
}

public extension View {
    func tabItem<V>(@ViewBuilder _ label: () -> V) -> some View where V: View {
        let labelView = label()
        let subViews = labelView.map(\.self)
        
        let image: Image? = subViews.compactMap { $0 as? Image } .first
        let text: Text? = subViews.compactMap { $0 as? Text } .first
        
        return TabItem(image: image, text: text, body: self)
    }
}
