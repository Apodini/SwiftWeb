//
//  PreviewProvider.swift
//  
//
//  Created by Quirin Schweigert on 15.05.20.
//

import Foundation

/// A type that produces view previews in Xcode for SwiftUI. Currently has no effect with the SwiftWeb framework.
public protocol PreviewProvider {
    associatedtype Previews: View
    static var previews: Self.Previews { get }
}
