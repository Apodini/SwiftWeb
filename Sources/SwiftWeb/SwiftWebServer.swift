//
//  SwiftWebServer.swift
//  SwiftWebServer
//
//  Created by Quirin Schweigert on 05.01.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation
import Swifter

public class SwiftWebServer {
    static let projectDirectoryName = "SwiftWebServer/"
    
    let server: HttpServer
    var staticFilesPath: String?

    public init<ContentView>(contentView: ContentView, path: String) where ContentView: View {
        server = HttpServer()
        staticFilesPath = getRessourceDirectoryPath(filePath: path)

        server["/"] = { request in
            return HttpResponse.ok(.text(SwiftWeb.render(view: contentView)))
        }
        
        server["/static/:path"] = { request in
            print("request: \(request.path)")
            
            guard let fileName = request.path.components(separatedBy: "/").last,
                let ressource = self.loadRessourceFile(name: fileName) else {
                    return HttpResponse.notFound
            }
            
            return HttpResponse.ok(.data(ressource))
        }
        
        server["/websocket"] = websocket(text: { session, text in
            print(text)
            session.writeText(text)
        }, connected: { _ in
            print("client connected")
        }, disconnected: { _ in
            print("client disconnected")
        })
    }
    
    func getRessourceDirectoryPath(filePath: String) -> String? {
        guard let cutIndex = filePath.range(of: Self.projectDirectoryName,
                                            options: .backwards)?.upperBound else {
            return nil
        }
        
        return String(filePath[..<cutIndex]) + "static/"
    }
    
    func loadRessourceFile(name: String) -> Data? {
        guard let staticFilesPath = staticFilesPath else {
            return nil
        }
        
        let ressourcePath = staticFilesPath.appending(name)
        return try? NSData(contentsOfFile: ressourcePath) as Data
    }
    
    public func port() throws -> Int {
        return try server.port()
    }
    
    public func start() throws {
        try server.start()
    }
}
