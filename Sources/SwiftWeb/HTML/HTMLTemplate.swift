//
//  HTMLTemplate.swift
//  
//
//  Created by Quirin Schweigert on 05.01.20.
//

import Foundation

/// The HTML template provided by SwiftWeb. Serve this with your HTTP server implementation.
public struct HTMLTemplate {
    /// Retrieve the template as a string. You can provide your custom content as an argument which will be replaced by the SwiftWeb
    /// JavaScript client once a connection to the server is established.
    public static func withContent(_ content: String) -> String {
        """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <script src="script.js"></script>
                <title>SwiftWeb</title>
                <style>
                    @font-face {
                        font-family: sf-pro-rounded-bold;
                        src: url(static/SF-Pro-Rounded-Bold.otf);
                    }
        
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
        
                        width: 100vw;
                        height: 100vh;
                    }
        
                    div {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        overflow: visible;
                    }
        
                    body > div {
                        align-self: stretch;
                        flex-grow: 1;
                    }
        
                    input {
                        -webkit-appearance: none;
                        border-width: 0px;
                        border: none;
                    }
        
                    input:focus {
                        outline: none;
                    }
        
                    * {
                        pointer-events: none;
                        flex-shrink: 0;
                        font-size: inherit;
                        font-weight: inherit;
                    }
                </style>
            </head>
            <body>
                \(content)
            </body>
            </html>
        """
    }
}
