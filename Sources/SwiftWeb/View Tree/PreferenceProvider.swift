//
//  ViewPreferences.swift
//
//
//  Created by Quirin Schweigert on 22.03.20.
//

import Foundation

/**
 A named value produced by a view.
 
 A view with multiple children automatically combines its values for a given preference into a single value visible to its ancestors.
 */
public protocol PreferenceKey: AnyPreferenceKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
}

protocol PreferenceProvider {
    var preferenceKeyType: AnyPreferenceKey.Type { get }
    var preferenceValue: Any { get }
}

/// Type-erased `PreferenceKey`.
public protocol AnyPreferenceKey {}

protocol PreferenceChangeListener {
    var preferenceKeyType: AnyPreferenceKey.Type { get }
    func onPreferenceChange(preferenceValue: Any?)
}

//protocol PreferenceProvider {
//    associatedtype P: PreferenceKey
//    var preferenceValue: P.Value { get }
//}

//extension TypeErasedPreferenceKey {
//    static func == (lhs: TypeErasedPreferenceKey, rhs: TypeErasedPreferenceKey) -> Bool {
//        return String(describing: lhs) == String(describing: rhs)
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(String(describing: self))
//    }
//}
