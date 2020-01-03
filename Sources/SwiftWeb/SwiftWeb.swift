//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public class SwiftWeb {
    public static func render<T>(view: T) -> String where T: View {
        return """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <title>SwiftWeb</title>
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        margin: 0;
                        cursor: default;
                        
                        -webkit-user-select: none;
                        -moz-user-select: none;
                        -ms-user-select: none;
                        user-select: none;
                    }
                </style>
            </head>
            <body>
                \(view.html.render())
            </body>
            </html>
        """
    }
}
