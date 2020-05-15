//
//  SwiftWebServer.swift
//  SwiftWebServer
//
//  Created by Quirin Schweigert on 05.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation

public class SwiftWebServer {
    let viewTree: ViewTree

    public init<ContentView>(contentView: ContentView) where ContentView: View {
        viewTree = ViewTree(withRootView: contentView)
    }
    
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
    
    public func handleClientConnect(session: WebSocketSession) {
        print("client connected")
        session.write(text: self.viewTree.render().string())
        print(self.viewTree.description)
    }
    
    public func handleClientDisconnect(session: WebSocketSession) {
        print("client disconnected")
    }
}

public protocol WebSocketSession {
    func write(text: String)
}

