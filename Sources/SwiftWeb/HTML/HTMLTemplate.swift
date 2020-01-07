//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

class HTMLTemplate {
    static func render(withBody body: String) -> String {
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
                        margin: 0;
                        cursor: default;
                        
                        -webkit-user-select: none;
                        -moz-user-select: none;
                        -ms-user-select: none;
                        user-select: none;
        
                        width: 100vw;
                        height: 100vh;
                    }
        
                    div {
                        display: flex;
                        align-items: center;
                        overflow: hidden;
                    }
                </style>
            </head>
            <body>
                \(body)
            </body>
            </html>
        """
    }
}
