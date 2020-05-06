//
//  Tag.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import Foundation
import SwiftAirtable


struct Tag {
    
    static let airtableViewName = "tags"
    
    /// this is the airtable ID field, This field **must** be public
    var id: String = ""
    
    private (set) var value: String = ""
    private var _category: String = ""
    
    var category: Category {
        Category(rawValue: _category) ?? .fruit
    }
    
    // MARK: - Airtable Fields
    
    enum AirtableField: String, CaseIterable {
        case tag
        case category
        
        var fieldType: AirtableTableSchemaFieldKey.KeyType {
            switch self {
            case .tag: return .singleLineText
            case .category: return .singleSelect
            }
        }
    }
    
}

// MARK: - Protocol Extension

extension Tag: AirtableObject {
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        
        tableSchemaKeys.forEach { element in
            guard let column = AirtableField(rawValue: element.key.fieldName) else { return }
            switch column {
            case .tag: self.value = element.value.stringValue
            case .category: self._category = element.value.stringValue
            }
        }
    }
    
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        AirtableField.allCases.compactMap { (fieldName: $0.rawValue, fieldType: $0.fieldType) }
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.tag.rawValue, fieldType: .singleLineText): return self.value
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.category.rawValue, fieldType: .singleSelect): return self._category
        default: return nil
        }
    }
    
}
