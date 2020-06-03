//
//  PreferenceProvidingView.swift
//
//
//  Created by Quirin Schweigert on 18.02.20.
//

import Foundation

struct PreferenceProvidingView<Body, Key>: View, PreferenceProvider
where Body: View, Key: PreferenceKey {
    var preferenceKeyType: AnyPreferenceKey.Type = Key.self
    var preferenceValue: Any
    
    var body: Body
    
    init(body: Body, preferenceValue: Key.Value) {
        self.body = body
        self.preferenceValue = preferenceValue
    }
}

public extension View {
    func preference<K>(key _: K.Type = K.self, value: K.Value)
        -> some View where K: PreferenceKey {
        PreferenceProvidingView<Self, K>(body: self, preferenceValue: value)
    }
}
