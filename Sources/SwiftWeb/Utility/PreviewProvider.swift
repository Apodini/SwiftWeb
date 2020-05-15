//
//  PreviewProvider.swift
//  
//
//  Created by Quirin Schweigert on 15.05.20.
//

import Foundation

public protocol PreviewProvider {
    associatedtype Previews : View
    static var previews: Self.Previews { get }
}
