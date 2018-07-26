# Usage

###  Decoding different types of data structures:

```swift
import Deco

let type = DoubleDecodable<Person, Address>.self
let output1 = try JSONDecoder().decode(type, from: data1)
let output2 = try JSONDecoder().decode(type, from: data2)

guard case let .first(value1)  = output1,
      case let .second(value2) = output2 else {
    //...
    return
}

let type = TripleDecodable<Person, Address, Zipcode>.self
let output1 = try JSONDecoder().decode(type, from: data1)
let output2 = try JSONDecoder().decode(type, from: data2)
let output3 = try JSONDecoder().decode(type, from: data2)

guard case let .first(value1)  = output1,
      case let .second(value2) = output2,
      case let .third(value3)  = output3 else {
//...
return
}

```

###  Getting an object tree's names and values:

```swift
import Deco

let typedValue = try JSONDecoder().decode(TypedValue.self, from: data)

switch typedValue {
case .string(let stringValue): 
    //...
    break
case .bool(let boolValue):
    //...
    break
case .int(let intValue):
    //...
    break
case .double(let doubleValue):
    //...
    break
case .array(let arrayValue):
    //...
    break
case .object(let objectValue):
    //...
    break
}

```
