//
//  File.swift
//  
//
//  Created by Quirin Schweigert on 03.01.20.
//

import Foundation

public struct TabBar: View {
    public var body: View? {
        VStack {
            HStack(spacing: 136.0) {
                Spacer()
                Text("Accounts")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(white: 0.58))
                Text("Transactions")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red:0.01, green:0.48, blue:1.00))
                Spacer()
            }
                .background(Color(white: 0.97))
                .frame(height: 73.0)
            Color(white: 0.77)
                .frame(height: 0.5)
        }
    }
    
    public init() {
        
    }
}
