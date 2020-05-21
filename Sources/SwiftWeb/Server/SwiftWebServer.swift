//
//  SwiftWebServer.swift
//  SwiftWebServer
//
//  Created by Quirin Schweigert on 05.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

/**
 A server managing connections with client browsers providing a user interface via HTML.
 */
public class SwiftWebServer {
    let viewTree: ViewTree

    /// Instantiates a `SwiftWebServer` instance with a root `View` specifying the user interface which is provided to clients.
    public init<ContentView>(contentView: ContentView) where ContentView: View {
        viewTree = ViewTree(withRootView: contentView)
    }
    
    /// Call this method for the server instance to handle an incoming message from a WebSocket client. SwiftWeb sends user input
    /// events which the JavaScript client captures over this connection.
    public func handleClientMessage(session: WebSocketSession, message: String) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        let inputEvent: InputEvent
        
        do {
            inputEvent = try JSONDecoder().decode(InputEvent.self, from: data)
        } catch let error {
            print("error decoding received input event: \(error)")
            return
        }
        
        print("received input event: \(inputEvent)")
        
        self.viewTree.handle(inputEvent: inputEvent)
        session.write(text: self.viewTree.render().string())
        print(self.viewTree.description)
    }
    
    /// Call this method whenever a new client connects to the WebSocket server you provide.
    public func handleClientConnect(session: WebSocketSession) {
        print("client connected")
        session.write(text: self.viewTree.render().string())
        print(self.viewTree.description)
    }
    
    /// Call this method whenever a client disconnects from your WebSocket server.
    public func handleClientDisconnect(session: WebSocketSession) {
        print("client disconnected")
    }
}

/// Represents a session of the WebSocket server you provide to a client browser.
public protocol WebSocketSession {
    
    /// Sends a message to the respective WebSocket client.
    func write(text: String)
}

