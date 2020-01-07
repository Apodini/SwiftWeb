//
//  NavigationBarTitle.swift
//  App
//
//  Created by Quirin Schweigert on 13.12.19.
//

import Foundation

public struct NavigationBarTitle: View {
    let title: String
    
    public var body: View? {
        Text(title)
            .font(.system(size: 35, weight: .bold))
    }
    
    public init(_ title: String) {
        self.title = title
    }
}

