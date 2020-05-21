//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 15.05.20.
//

import Foundation

/// The JavaScript client provided by SwiftWeb. Serve this script for the '/script.js' path on your HTTP server.
public struct JavaScriptClient {
    /// The script code as a `String`.
    public static var script: String {
        """
        console.log("connecting...");
        let socket = new WebSocket(`ws://${window.location.host}/websocket`);
        
        socket.onopen = (event) => {
            console.log("connected to application");
        };
        
        socket.onmessage = (event) => {
            document.body.innerHTML = event.data;
            console.log("body updated")
        };
        
        document.onclick = (event) => {
            let viewID = findResponderID(event.target, "click-event-responder")
            
            if (event.target.tagName === "INPUT") {
                return
            }
            
            if (viewID !== null) {
                console.log(`click on ${viewID}`);
                
                socket.send(JSON.stringify({
                    click: {
                        id: viewID,
                    }
                }));
            }
        };
        
        document.onchange = (event) => {
            let viewID = findResponderID(event.target, "change-event-responder")
            
            if (viewID !== null) {
                socket.send(JSON.stringify({
                    change: {
                        id: viewID,
                        newValue: event.srcElement.value,
                    }
                }));
            }
        };
        
        // bubbles the event up from `target` to return the id of the first element with `attribute`
        function findResponderID(target, attribute) {
            let currentElement = target;
            
            while (true) {
                if (currentElement.hasAttribute(attribute)) {
                    return currentElement.getAttribute("id");
                }
                
                if (currentElement.parentElement !== null) {
                    currentElement = currentElement.parentElement;
                } else {
                    return null;
                }
            }
        }
        """
    }
}
