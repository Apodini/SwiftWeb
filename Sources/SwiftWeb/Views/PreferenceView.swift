//
//  PreferenceView.swift
//  
//
//  Created by Quirin Schweigert on 18.02.20.
//

import Foundation

protocol TypeErasedPreferenceView {
    var typeErasedPreferenceValue: Any { get }
}

struct PreferenceView<Body, Key>: View, TypeErasedPreferenceView
    where Body: View, Key: PreferenceKey {
        public var body: Body
        var preferenceValue: Key.Value
        
        var typeErasedPreferenceValue: Any {
            preferenceValue
        }
        
        public init(body: Body, preferenceValue: Key.Value) {
            self.body = body
            self.preferenceValue = preferenceValue
        }
}

public protocol PreferenceKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
}

public extension View {
    private func preferenceValue<Key>(forKey key: Key.Type)
        -> Key.Value where Key: PreferenceKey {

            let preferenceValuesInSubTree = deepMap { subView -> Key.Value? in
                if let typeErasedPreferenceView = subView as? TypeErasedPreferenceView,
                    let value = typeErasedPreferenceView.typeErasedPreferenceValue
                        as? Key.Value {
                    return value
                }
                
                return nil
            }
                .compactMap { $0 }
            
            return preferenceValuesInSubTree.last ?? Key.defaultValue // todo: apply reduce if multiple values are present
    }
    
    func preference<K>(key _: K.Type = K.self, value: K.Value)
        -> some View where K : PreferenceKey {
    
        return PreferenceView<Self, K>(body: self, preferenceValue: value)
    }
    
    func onPreferenceChange<K>(_ key: K.Type = K.self,
                               perform action: (K.Value) -> Void) // escaping ?
        -> some View where K : PreferenceKey { //, K.Value : Equatable
            action(preferenceValue(forKey: K.self))
            return self
    }
}
