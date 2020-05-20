//
//  Sequence+keypath.swift
//  App
//
//  Created by Quirin Schweigert on 02.01.20.
//

import Foundation

public extension Sequence {
    /// Returns an array containing the results of mapping the elements to the specified `KeyPath`.
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return self.map {
            $0[keyPath: keyPath]
        }
    }
    
    /// Returns an array containing the non-nil results of mapping the elements of this sequence to the specified `KeyPath`.
    func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return self.compactMap {
            $0[keyPath: keyPath]
        }
    }
}
