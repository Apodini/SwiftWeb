//
//  PreferenceChangeListenerView.swift
//  
//
//  Created by Quirin Schweigert on 31.03.20.
//

import Foundation

struct PreferenceChangeListenerView<Body, Key>: View, PreferenceChangeListener
where Body: View, Key: PreferenceKey {
    let preferenceKeyType: AnyPreferenceKey.Type = Key.self
    let onPreferenceChangeClosure: (Key.Value) -> Void
    
    var body: Body
    
    func onPreferenceChange(preferenceValue: Any?) { }
    
    init(body: Body,
         preferenceKey: Key.Type,
         onPreferenceChangeClosure: @escaping (Key.Value) -> Void) {
        self.body = body
        self.onPreferenceChangeClosure = onPreferenceChangeClosure
    }
}

public extension View {
        func onPreferenceChange<K>(_ key: K.Type = K.self,
                                   perform action: @escaping (K.Value) -> Void)
            -> some View where K: PreferenceKey {
                PreferenceChangeListenerView(body: self,
                                             preferenceKey: key,
                                             onPreferenceChangeClosure: action)
        }
}
