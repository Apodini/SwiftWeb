//
//  NavigationView.swift
//  
//
//  Created by Quirin Schweigert on 08.02.20.
//

import Foundation

public struct NavigationView<Content>: View where Content: View {
    let content: Content
    var navigationBarTitle: String
    var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        (self.navigationBarTitle, self.navigationBarTitleDisplayMode) = NavigationBarTitleKey.defaultValue
        _ = self.content.onPreferenceChange(NavigationBarTitleKey.self) { value in
            (self.navigationBarTitle, self.navigationBarTitleDisplayMode) = value
        }
    }
    
    public var body: some View {
        VStack {
            (navigationBarTitleDisplayMode == .inline ?
                inlineTitleBar.anyView() : largeTitleBar.anyView())

            content
        }
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
        }
            .padding(.leading, 15)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}
