//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public class SwiftWeb {
    public static func render<T>(view: T) -> String where T: View {
        HTMLTemplate.render(withBody: view.html.render())
    }
}
