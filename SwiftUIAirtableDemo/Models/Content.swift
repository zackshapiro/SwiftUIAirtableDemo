//
//  Content.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import Foundation
import SwiftAirtable

enum ViewType: String {
    case hi = "HiView"
    case bye = "ByeView"
    case middle = "MiddleView"
    case settings = "SettingsView"
}

struct Content: Equatable {
    
    static let airtableViewName = "content"
        
    /// this is the airtable ID field, This field **must** be public
    var id: String = ""
    
    private var _type: String = ""
    var type: ViewType {
        ViewType(rawValue: _type) ?? .hi
    }
    private (set) var title: String = ""
    private (set) var position: Int = 0
    
    // MARK: - Airtable Fields
    
    enum AirtableField: String, CaseIterable {
        case view
        case position
        case title
        
        var fieldType: AirtableTableSchemaFieldKey.KeyType {
            switch self {
            case .view: return .singleSelect
            case .position: return .number
            case .title: return .singleLineText
            }
        }
    }
    
}

// MARK: - Protocol Extension

extension Content: AirtableObject {
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        
        tableSchemaKeys.forEach { element in
            guard let column = AirtableField(rawValue: element.key.fieldName) else { return }
            switch column {
            case .view: self._type = element.value.stringValue
            case .position: self.position = element.value.intValue
            case .title: self.title = element.value.stringValue
            }
        }
    }
    
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        AirtableField.allCases.compactMap { (fieldName: $0.rawValue, fieldType: $0.fieldType) }
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.view.rawValue, fieldType: .singleSelect): return self._type
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.position.rawValue, fieldType: .number): return self.position
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.title.rawValue, fieldType: .singleLineText): return self.title
        default: return nil
        }
    }

}
