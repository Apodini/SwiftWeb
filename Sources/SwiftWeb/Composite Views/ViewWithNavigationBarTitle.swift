//
//  ViewWithNavigationBarTitle.swift
//  
//
//  Created by Quirin Schweigert on 18.02.20.
//

import Foundation

struct NavigationBarTitleKey: PreferenceKey {
    static var defaultValue: (String, NavigationBarItem.TitleDisplayMode) = ("", .automatic)
    
    static func reduce(value: inout (String, NavigationBarItem.TitleDisplayMode),
                       nextValue: () -> (String, NavigationBarItem.TitleDisplayMode)) {
        value = nextValue()
    }
}

// This view holds a title which a containing NavigationView can read and
// display
struct ViewWithNavigationBarTitle<Content>: View where Content: View {
    let content: Content
    let navigationBarTitle: String
    let navigitonBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    
    public init(content: Content,
                navigationBarTitle: String,
                navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic) {
        self.content = content
        self.navigationBarTitle = navigationBarTitle
        self.navigitonBarTitleDisplayMode = navigationBarTitleDisplayMode
    }
    
    var body: some View {
        content.preference(key: NavigationBarTitleKey.self,
                           value: (navigationBarTitle, navigitonBarTitleDisplayMode))
    }
}

public extension View {
    func navigationBarTitle(_ title: String,
                            displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        return ViewWithNavigationBarTitle(
            content: self,
            navigationBarTitle: title,
            navigationBarTitleDisplayMode: displayMode
        )
    }
}

public struct NavigationBarItem {
    public enum TitleDisplayMode: Int, Equatable {
        case automatic
        case inline
        case large
    }
}
