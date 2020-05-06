
# SwiftAirtable

![Alt Text](https://github.com/nicolasnascimento/SwiftAirtable/blob/master/SwiftAirtableDemo3.gif)

## Description
An unofficial Swift interface to Airtable's REST API

## Usage
In order to make use of the Framework, simply create a strucuture

```Swift
struct AirtablePerson {
    // The airtable object id
    var id: String = ""
    var name: String = ""
}
```

and make it adopt the AirtableObject protocol

```Swift
extension AirtablePerson: AirtableObject {
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        var fields = [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)]()
        fields.append((fieldName: AirtableField.name.rawValue, fieldType: .singleLineText))
        return fields
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.name.rawValue, fieldType: .singleLineText): return self.name
        default: return nil
        }
    }
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        tableSchemaKeys.forEach { element in
            switch element.key {
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.name.rawValue, fieldType: .singleLineText): self.name = element.value.stringValue
            default: break
            }
        }
    }
}
```
Finally create an Airtable to perform the operations
```Swift
let airtable = Airtable(apiKey: apiKey, apiBaseUrl: apiBaseUrl, schema: AirtablePerson.schema)
```

You can perform all standard CRUD operations

### Create
```Swift
airtable.createObject(with: object, inTable: table) { object: AirtablePerson, error: Error? in
    if let error = error {
        // Error Code
    } else {
        // Sucess Code
    }
}
```
### Retrieve
```Swift
airtable.fetchAll(table: table) { (objects: [AirtablePerson], error: Error?) in
    if let error = error {
        // Sucess Code
    } else {
        // Erro Code
    }
}
```

### Update
```Swift
airtable.updateObject(with: object, inTable: table) { object: AirtablePerson?, error: Error? in
    if let error = error {
        // Sucess Code
    } else {
        // Erro Code
    }
}
```

### Delete
```Swift
airtable.deleteObject(with: object, inTable: table) { sucess, error in
    if let error = error {
        // Error Code
    } else {
        // Sucess Code
    }
}
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.
You'll need to provide your API Key and Base URL.

## Installation

SwiftAirtable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftAirtable'
```

## Author

Nicolas Nascimento, npn.adsl@gmail.com

## Soucery

An stencil file is provided in the repo that allows you generate code for the AirtableObject protocol using Sourcery (https://github.com/krzysztofzablocki/Sourcery)

## License

SwiftAirtable is available under the MIT license. See the LICENSE file for more info.
