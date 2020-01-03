//
//  Sequence+keypath.swift
//  App
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

public extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return self.map {
            $0[keyPath: keyPath]
        }
    }
    
    func flatMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return self.compactMap {
            $0[keyPath: keyPath]
        }
    }
}
