//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct TabBar: View {
    public var body: View? {
        VStack(alignment: .stretch) {
            HStack(spacing: 136.0) {
                Spacer()
                VStack(spacing: 7) {
                    Text("Accounts")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(white: 0.58))
                    Image(name: "rectangle.stack.png")
                        .resizable()
                        .frame(width: 22.0, height: 20.0)
                }

                VStack(spacing: 7) {
                    Text("Transactions")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(red:0.01, green:0.48, blue:1.00))
                    Image(name: "list.dash.png")
                        .resizable()
                        .frame(width: 22.0, height: 20.0)
                }

                Spacer()
            }
                .frame(height: 73.0)
            
            Color(white: 0.77)
                .frame(height: 0.5)
        }
            .background(Color(white: 0.97))

    }
    
    public init() {
        
    }
}
