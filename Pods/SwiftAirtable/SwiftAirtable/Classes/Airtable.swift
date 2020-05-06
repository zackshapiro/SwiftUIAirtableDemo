//  Copyright (c) 2018 Nicolas Pereira do Nascimento
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
// MARK: - Airtable Value

/// Represents an object that can be saved in Airtable
public protocol AirtableValue {
    var stringValue: String { get }
    var intValue: Int { get }
    var doubleValue: Double { get }
    var dateValue: Date { get }
    var urlValue: URL? { get }
    var boolValue: Bool { get }
    var arrayValue: [AirtableValue] { get }
    var dictionaryValue: [String: AirtableValue] { get }
}

// MARK: - Airtable Value Default Implementation

// Most types won't adopt all types, so they get this default implementation
extension AirtableValue {
    public var intValue: Int { return Int.min }
    public var doubleValue: Double { return Double.nan }
    public var dateValue: Date { return Date(timeIntervalSince1970: 0) }
    public var arrayValue: [AirtableValue] { return [] }
    public var urlValue: URL? { return nil }
    public var boolValue: Bool { return false }
    public var dictionaryValue: [String: AirtableValue] { return [:] }
}

// Most types will get stringValue for free
extension AirtableValue where Self: CustomStringConvertible {
    public var stringValue: String { return self.description }
}

extension String: AirtableValue {}
extension NSString: AirtableValue {}
extension Int: AirtableValue {
    public var intValue: Int { return self }
}
extension Double: AirtableValue {
    public var doubleValue: Double { return self }
}
extension Date: AirtableValue {
    public var dateValue: Date { return self }
}
extension NSDate: AirtableValue {
    public var dateValue: Date { return self as Date }
}
extension Bool: AirtableValue {
    public var boolValue: Bool { return self }
}

// TODO: Possible extend this to encapsulate more generic types, such as Collection or even Sequence
extension Array: AirtableValue {
    public var arrayValue: [AirtableValue] {
        return self as? [AirtableValue] ?? []
    }
}

extension Dictionary: AirtableValue {
    public var dictionaryValue: [String : AirtableValue] {
        return self as? [String: AirtableValue] ?? [:]
    }
}

// MARK: - Attachment

// Attachment is both an Airtable object and an Airtable value
public struct AirtableAttachment {
    // We'll use this to keep track of changes and propertly update object in airtable
    fileprivate(set) var updatedUrl: Bool = false
    
    public var fileName: String
    public var url: String {
        didSet {
            self.updatedUrl = ( self.updatedUrl || self.url != oldValue)
        }
    }
}

extension AirtableAttachment: Equatable {
    public static func ==(lhs: AirtableAttachment, rhs: AirtableAttachment) -> Bool {
        return lhs.fileName == rhs.fileName && lhs.url == rhs.url
    }
}

extension AirtableAttachment: Hashable {
    public var hashValue: Int {
        return self.fileName.hashValue + self.url.hashValue
    }
}

extension AirtableAttachment {
    public init(fileName: String, url: String) {
        self.fileName = fileName
        self.url = url
    }
}

extension AirtableAttachment: AirtableValue {
    public var stringValue: String { return "AirtableAttachment - (id:\(""), url:\(self.url)" }
    public var urlValue: URL? { return URL(string: self.url) }
}

// MARK: - Airtable Table Schema Field
public struct AirtableTableSchemaFieldKey: Codable {
    public var fieldName: String
    public var fieldType: KeyType
    
    public init(fieldName: String, fieldType: KeyType) {
        self.fieldName = fieldName
        self.fieldType = fieldType
    }
}


extension AirtableTableSchemaFieldKey: Equatable {
    public static func ==(lhs: AirtableTableSchemaFieldKey, rhs: AirtableTableSchemaFieldKey) -> Bool {
        return lhs.fieldName == rhs.fieldName && lhs.fieldType == rhs.fieldType
    }
}

extension AirtableTableSchemaFieldKey: Hashable {
    public var hashValue: Int {
        // This is a workable hack to fix the crash that happens here. Haven't had time to investigate here
        return Int(arc4random_uniform(UInt32(2500)))

        
        //        return fieldName.hashValue + fieldType.hashValue <- this crashes intermittently
    }
}

extension AirtableTableSchemaFieldKey {
    public enum KeyType: String, Codable {
        case singleLineText = "singleLineText"
        case singleSelect = "singleSelect"
        case number = "number"
        case linkToAnotherRecord = "linkToAnotherRecord"
        case dateWithHour = "dateWithHour"
        case attachment = "attachment"
        case checkbox = "checkbox"
    }
}

// MARK: - Airtable Object Protocol
public protocol AirtableObject {
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] { get }
    
    var id: String { get set }
    
    // MARK: -  Default Implementation Provided
    func populateAllFields(inEmptyTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey]) -> [AirtableTableSchemaFieldKey: AirtableValue]
    
    // MARK: - Required
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue?
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey: AirtableValue])
}

// MARK: - Airtable Object Protocol - Default Implementation
extension AirtableObject {
    static public var schema: AirtableTableSchema {
        let keys = Self.fieldKeys.map{ return AirtableTableSchemaFieldKey(fieldName: $0.fieldName, fieldType: $0.fieldType) }
        return AirtableTableSchema(fieldsKeys: keys)
    }
    
    public func populateAllFields(inEmptyTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey]) -> [AirtableTableSchemaFieldKey : AirtableValue] {
        return
            tableSchemaKeys
                .map{ (element) -> (key: AirtableTableSchemaFieldKey, value: AirtableValue?) in
                    return (element, self.value(forKey: element))
                }
                .reduce([AirtableTableSchemaFieldKey: AirtableValue]()) { (currentResult, element) in
                    var returnValue = currentResult
                    returnValue[element.key] = element.value
                    return returnValue
        }
    }
}

// MARK: - Airtable Table Schema
public struct AirtableTableSchema: Codable {
    public var fieldsKeys: [AirtableTableSchemaFieldKey]
    
    public init(fieldsKeys: [AirtableTableSchemaFieldKey]) {
        self.fieldsKeys = fieldsKeys
    }
}



extension AirtableTableSchema: Equatable {
    public static func ==(lhs: AirtableTableSchema, rhs: AirtableTableSchema) -> Bool {
        return lhs.fieldsKeys == rhs.fieldsKeys
    }
}

// MARK: - Airtable
public struct Airtable: Equatable, Codable {
    
    // MARK: - Public
    
    /// The key generated in the Airtable dashboard
    fileprivate let apiKey: String
    
    /// The default path to be used during construction of url
    fileprivate let apiBaseUrl: String
    
    /// The default schema used when performing queries
    fileprivate let tableSchema: AirtableTableSchema
    
    // MARK: - Init
    public init(apiKey: String, apiBaseUrl: String, schema: AirtableTableSchema) {
        self.apiKey = apiKey
        self.apiBaseUrl = apiBaseUrl
        self.tableSchema = schema
    }
    
    // MARK: - Public
    public func fetchAll<T>(table: String, with completion: @escaping (_ objects: [T], _ error: Error?) -> Void) where T: AirtableObject {
        
        // Mount URL
        let stringUrl = self.apiBaseUrl + "/" + table.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let url =  URL(string: stringUrl) else {
            print("Invalid URL \(stringUrl)")
            return
        }
        // Create task
        let task = self.readAuthorizedSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([], error)
            } else if let data = data {
                self.handleFetchResponse(with: data, completion: completion)
            }
        }
        // Start task
        task.resume()
    }
    public func fetchObject<T>(identifiedBy id: String, inTable table: String, with completion: @escaping (_ objects: [T], _ error: Error?) -> Void) where T: AirtableObject {
        
        // Mount URL
        guard let url =  URL(string: self.apiBaseUrl + "/" + table.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "/" + id) else {
            print("Invalid URL")
            return
        }
        
        // Create task
        let task = self.readAuthorizedSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([], error)
            } else if let data = data {
                self.handleFetchResponse(with: data, completion: completion)
            }
        }
        // Start task
        task.resume()
    }
    public func createObject<T>(with object: T, inTable table: String, with completion: @escaping (_ object: T?, _ error: Error?) -> Void) where T: AirtableObject {
        
        // Mount URL
        guard let url = URL(string: self.apiBaseUrl + "/" + table.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else {
            print("Invalid URL")
            return
        }
        // Mount proper url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            // Gather data for object and set it to url request body
            let jsonObject = try self.data(of: object, for: tableSchema)
            urlRequest.httpBody = jsonObject
            
            // Create task
            let task = self.writeAuthorizedSession.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    self.handleFetchResponse(with: data) { (objects, error) in
                        completion(objects.first, error)
                    }
                }
            }
            // Start task
            task.resume()
        } catch {
            completion(nil, error)
        }
    }
    public func updateObject<T>(with object: T, inTable table: String, with completion: @escaping (_ object: T?, _ error: Error?) -> Void) where T: AirtableObject {
        
        // Mount URL
        guard let url =  URL(string: self.apiBaseUrl + "/" + table.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "/" + object.id) else {
            print("Invalid URL")
            return
        }
        
        // Mount proper url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            // Gather data for object and set it to url request body
            let jsonObject = try self.data(of: object, for: tableSchema)
            urlRequest.httpBody = jsonObject
            
            // Create tasks
            let task = self.writeAuthorizedSession.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    self.handleFetchResponse(with: data) { (objects, error) in
                        completion(objects.first, error)
                    }
                }
            }
            // Start task
            task.resume()
        } catch {
            completion(nil, error)
        }
    }
    public func deleteObject<T>(with object: T,  inTable table: String, with completion: @escaping (_ deleted: Bool, _ error: Error?) -> Void) where T: AirtableObject {
        // Mount URL
        guard let url = URL(string: self.apiBaseUrl + "/" + table.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "/" + object.id) else {
            print("Invalid URL")
            return
        }
        
        // Mount proper url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        let task = self.readAuthorizedSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(false, error)
            } else if let data = data {
                do {
                    // Downloaded Variables
                    let jsonValue = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let operationResult = jsonValue?["deleted"] as? Bool {
                        completion(operationResult, nil)
                    } else {
                        completion(false, AirtableResponseError.invalidFormat)
                    }
                } catch {
                    completion(false, AirtableResponseError.invalidFormat)
                }
            }
        }
        // Start task
        task.resume()
        
    }
    // MARK: - Private
    fileprivate func handleFetchResponse<T>(with data: Data, completion: @escaping (_ objects: [T], _ error: Error?) -> Void) where T: AirtableObject {
        do {
            // Downloaded Variables
            let jsonValue = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let results = jsonValue?["records"] as? [[String: Any]] {
                
                // Objects to return
                let objects: [T] = self.extractObjects(fromJsonRecords: results, following: tableSchema)
                
                // Forward objects
                completion(objects, nil)
            } else if let result = jsonValue {
                
                // Objects to return
                let objects: [T] = self.extractObjects(fromJsonRecords: [result], following: tableSchema)
                
                // Forward objects
                completion(objects, nil)
                
            } else {
                // Forward proper error
                completion([], AirtableResponseError.invalidFormat)
            }
        } catch {
            // Forward error handling
            completion([], error)
        }
    }
    // For each object, extract its id and fields
    fileprivate func extractObjects<T>(fromJsonRecords jsonRecords: [[String: Any]], following tableSchema: AirtableTableSchema) -> [T] where T: AirtableObject {
        // Call extract object for every object (passing the json of the object)
        return jsonRecords.compactMap{ (record) -> T? in
            guard let fields = record["fields"] as? [String: Any], let id = record["id"] as? String else { return nil }
            return self.extractObject(fromJsonFields: fields, identifiedBy: id, following: tableSchema)
        }
    }
    // Extracts fields specified in the table schema
    fileprivate func extractObject<T>(fromJsonFields fields: [String: Any], identifiedBy id: String, following tableSchema: AirtableTableSchema) -> T where T: AirtableObject {
        // Object to store properties
        var airtableObject: [AirtableTableSchemaFieldKey: AirtableValue] = [:]
        tableSchema.fieldsKeys.forEach({ (key) in
            
            // Filter fields to the one matching the specific key and mount obj
            if let matchingElement = fields.filter({ $0.key == key.fieldName }).first {
                switch key.fieldType {
                case .singleLineText, .singleSelect: airtableObject[key] = matchingElement.value as? String
                case .number: airtableObject[key] = matchingElement.value as? Int
                case .checkbox: airtableObject[key] = (matchingElement.value as? Bool) ?? false
                case .linkToAnotherRecord: airtableObject[key] = matchingElement.value as? [String]
                case .dateWithHour:
                    // We need to extract the date from the string saved in the JSON
                    guard let stringData = matchingElement.value as? String else { return }
                    airtableObject[key] = DateFormatter.airtableDateFormatter.date(from: stringData)//?.addingTimeInterval(hours)
                case .attachment:
                    for value in matchingElement.value as? [[String: Any]] ?? [] {
                        guard let fileName = value["filename"] as? String, let url = value["url"] as? String else { continue }
                        var allAttachments: [AirtableAttachment] = (airtableObject[key] as? [AirtableAttachment]) ?? []
                        let attachment = AirtableAttachment(fileName: fileName, url: url)
                        allAttachments.append(attachment)
                        airtableObject[key] = allAttachments
                    }
                }
                
            } else {
                print("Warning: - Couldn't find fieldName '\(key.fieldName)' in received object (did you use an wrong schema?)")
            }
        })
        return T(withId: id, populatedTableSchemaKeys: airtableObject)
    }
    fileprivate func data<T>(of object: T, for tableSchema: AirtableTableSchema) throws -> Data where T: AirtableObject {
        return try JSONSerialization.data(withJSONObject: self.json(of: object, for: tableSchema), options: [])
    }
    // Extracts the json from an Airtable object representation
    fileprivate func json<T>(of object: T, for tableSchema: AirtableTableSchema) -> [String: Any] where T: AirtableObject {
        let fields: [String: Any] = object.populateAllFields(inEmptyTableSchemaKeys: tableSchema.fieldsKeys).map { (element) -> [String: Any] in
            var field = [String: Any]()
            switch element.key.fieldType {
            case .singleLineText, .singleSelect: field[element.key.fieldName] = element.value.stringValue
            case .number: field[element.key.fieldName] = element.value.intValue
            case .checkbox: field[element.key.fieldName] = element.value.boolValue
            case .linkToAnotherRecord: field[element.key.fieldName] = element.value.arrayValue
            case .dateWithHour:
                if element.value.dateValue != Date(timeIntervalSince1970: 0) {
                    // Get correct date formatter
                    field[element.key.fieldName] = DateFormatter.airtableDateFormatter.string(from: element.value.dateValue).split(separator: ".").first!.description + ".000Z"
                }
            case .attachment:
                // Try to get single or multiple attachments
                let attachments: [AirtableAttachment] = element.value is AirtableAttachment ? [element.value as! AirtableAttachment] : (element.value as? [AirtableAttachment] ?? [])
                
                // Add associated attachments
                let jsonAttachments = attachments.reduce(into: [[String: Any]]()) { $0.append(["filename": $1.fileName, "url": $1.url]) }
                field[element.key.fieldName] = jsonAttachments
            }
            return field
            }.reduce([String: Any](), { (currentFields, field) -> [String: Any] in
                return currentFields.merging(field, uniquingKeysWith: { (current, _) in current })
            })
        return ["fields" : fields]
    }
}


extension DateFormatter {
    static let airtableDateFormatter: DateFormatter = {
        // We need to extract the date from the string saved in the JSON
        let dateFormatter = DateFormatter()
        
        // We may set locale and format to get send properly to Airtable, as it'll always receive dates in 24h style
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        
        return dateFormatter
    }()
}


extension Airtable {
    
    // MARK: - Error Definitions
    public enum AirtableResponseError: String, Error {
        case invalidFormat = "Error: Airtable Response with Invalid Format"
        var localizedDescription: String { return self.rawValue }
    }
    
    // MARK: - URL Session and Headers
    fileprivate var airtableAuthorizationHeader: [AnyHashable : Any] {
        return ["Authorization" : ("Bearer " + self.apiKey)]
    }
    fileprivate var airtableWriteHeader: [AnyHashable: Any] {
        return [
            "Authorization" : ("Bearer " + self.apiKey),
            "Content-Type" : "application/json"
        ]
    }
    fileprivate var readAuthorizedSession: URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.airtableAuthorizationHeader
        return URLSession(configuration: sessionConfiguration)
    }
    fileprivate var writeAuthorizedSession: URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.airtableWriteHeader
        return URLSession(configuration: sessionConfiguration)
    }
}
