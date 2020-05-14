//
//  InputEvent.swift
//  
//
//  Created by Quirin Schweigert on 29.03.20.
//

import Foundation

public enum InputEvent {
    case click(id: UUID)
    case change(id: UUID, newValue: String)
}

extension InputEvent: Codable {
    private enum CodingKeys: String, CodingKey {
        case click
        case change
    }
    
    private enum AssociatedValuesCodingKeys: String, CodingKey {
        case id
        case newValue
    }
    
    enum InputEventCodingError: Error {
        case decoding(String)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .click(let id):
            var associatedValuesContainer = container.nestedContainer(
                keyedBy: AssociatedValuesCodingKeys.self,
                forKey: .click
            )
            
            try associatedValuesContainer.encode(id, forKey: .id)
            
        case .change(let id, let value):
            var associatedValuesContainer = container.nestedContainer(
                keyedBy: AssociatedValuesCodingKeys.self,
                forKey: .change
            )
            
            try associatedValuesContainer.encode(id, forKey: .id)
            try associatedValuesContainer.encode(value, forKey: .newValue)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.click) {
            let clickAssociatedValuesContainer = try values.nestedContainer(
                keyedBy: AssociatedValuesCodingKeys.self,
                forKey: .click
            )
            
            let id = try clickAssociatedValuesContainer.decode(UUID.self, forKey: .id)
            
            self = .click(id: id)
            
        } else if values.contains(.change) {
            let clickAssociatedValuesContainer = try values.nestedContainer(
                keyedBy: AssociatedValuesCodingKeys.self,
                forKey: .change
            )
            
            let id = try clickAssociatedValuesContainer.decode(UUID.self, forKey: .id)
            let newValue = try clickAssociatedValuesContainer.decode(String.self, forKey: .newValue)
            
            self = .change(id: id, newValue: newValue)
        } else {
            throw InputEventCodingError.decoding(String(reflecting: values))
        }
    }
}
