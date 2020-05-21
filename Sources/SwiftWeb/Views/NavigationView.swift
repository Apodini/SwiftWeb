//
//  NavigationView.swift
//  
//
//  Created by Quirin Schweigert on 08.02.20.
//

import Foundation

/// A view for presenting a stack of views representing a visible path in a navigation hierarchy. Currently, only the display of a title bar is implemented, no navigation is possible yet with SwiftWeb.
public struct NavigationView<Content>: View where Content: View {
    let content: Content
    var navigationBarTitle: String
    var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    var trailingContent: TypeErasedView
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        (self.navigationBarTitle, self.navigationBarTitleDisplayMode) =
            NavigationBarTitleKey.defaultValue
        trailingContent = Spacer()
        
//        _ = self.content.onPreferenceChange(NavigationBarTitleKey.self) { value in
//            (self.navigationBarTitle, self.navigationBarTitleDisplayMode) = value
//        }
//        
//        _ = self.content.onPreferenceChange(TrailingNavigationBarItemsKey.self) { value in
//            trailingContent = value ?? Spacer()
//        }
    }
    
    public var body: some View {
        VStack {
            (navigationBarTitleDisplayMode == .inline ?
                inlineTitleBar.anyView() : largeTitleBar.anyView())

            content
        }
//            .preference(key: NavigationBarTitleKey.self,
//                        value: NavigationBarTitleKey.defaultValue)
//            .preference(key: TrailingNavigationBarItemsKey.self,
//                        value: TrailingNavigationBarItemsKey.defaultValue)
    }
    
    var inlineTitleBar: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(navigationBarTitle)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            .frame(height: 50)
            .background(Color(red:0.98, green:0.98, blue:0.99))
            
            Color(white: 0.73)
                .frame(height: 0.5)
        }
    }
    
    var largeTitleBar: some View {
        HStack {
            Text(navigationBarTitle)
                .font(.system(size: 35, weight: .bold))
            Spacer()
            trailingContent.anyView()
        }
            .padding(.leading, 15)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}

struct NavigationBarTitleKey: PreferenceKey {
    static var defaultValue: (title: String, displayMode: NavigationBarItem.TitleDisplayMode) = ("", .automatic)
    
    static func reduce(value: inout (title: String, displayMode: NavigationBarItem.TitleDisplayMode),
                       nextValue: () -> (title: String, displayMode: NavigationBarItem.TitleDisplayMode)) {
        value = nextValue()
    }
}

struct TrailingNavigationBarItemsKey: PreferenceKey {
    static var defaultValue: TypeErasedView? = nil
    
    static func reduce(value: inout TypeErasedView?,
                       nextValue: () -> TypeErasedView?) {
        value = nextValue()
    }
}

public extension View {
    func navigationBarTitle(_ title: String,
                            displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        self.preference(key: NavigationBarTitleKey.self, value: (title, displayMode))
    }
    
    func navigationBarItems<T>(trailing: T) -> some View where T : View {
        self//.preference(key: TrailingNavigationBarItemsKey.self, value: trailing)
    }
}

/// A configuration for a navigation bar that represents a view at the top of a navigation stack.
public struct NavigationBarItem {
    
    /// A style for displaying the title of a navigation bar.
    public enum TitleDisplayMode: Int, Equatable {
        /// Inherit the display mode from the previous navigation item.
        case automatic
        
        /// Display the title within the standard bounds of the navigation bar.
        case inline
        
        /// Display a large title within an expanded navigation bar.
        case large
    }
}
