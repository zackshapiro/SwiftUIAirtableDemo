//
//  AirtableService.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import Foundation
import SwiftAirtable

struct AirtableService {
    
    private static let apiKey = ""
    private static let apiBaseUrl = ""
    
    static func fetchContent(completion: @escaping (Result<[Content], Error>) -> Void) {
        let airtable = Airtable(apiKey: apiKey, apiBaseUrl: apiBaseUrl, schema: Content.schema)
        airtable.fetchAll(table: Content.airtableViewName) { (content: [Content] , error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let sortedContent = content.sorted { $0.position < $1.position }
                completion(.success(sortedContent))
            }
        }
    }
    
    static func fetchTags(completion: @escaping (Result<[Tag], Error>) -> Void) {
        let airtable = Airtable(apiKey: apiKey, apiBaseUrl: apiBaseUrl, schema: Tag.schema)
        airtable.fetchAll(table: Tag.airtableViewName) { (content: [Tag] , error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(content))
            }
        }
    }
    
}
