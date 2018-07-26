//**************************************************************
//
//  BasicValue
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public indirect enum TypedValue {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    case array([TypedValue])
    case object([String: TypedValue])
}

extension TypedValue {
    var rawValue: Any {
        switch self {
        case .string(let value): return value
        case .bool(let value):   return value
        case .int(let value):    return value
        case .double(let value): return value
        case .array(let value):  return value.map { $0.rawValue }
        case .object(let value): return value.mapValues { $0.rawValue }
        }
    }
}

extension TypedValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let value): return "\"\(value)\""
        case .bool(let value):   return value.description
        case .int(let value):    return value.description
        case .double(let value): return value.description
        case .array(let value):  return value.description
        case .object(let value): return value.description
        }
    }
}

extension TypedValue: Decodable {
    public init(from decoder: Decoder) throws {
        guard let value = TypedValue.decodeMap(from: decoder) ??
                        TypedValue.decodeArray(from: decoder) ??
                        TypedValue.decodeSingle(from: decoder) else {
            throw Error.invalidData
        }
        self = value
    }

    private static func decodeMap(from decoder: Decoder) -> TypedValue? {
        guard let keys = try? decoder.container(keyedBy: Keys.self) else {
            return nil
        }

        let allKeys = keys.allKeys
        guard !allKeys.isEmpty && allKeys.first?.intValue == nil else {
            return nil
        }

        var entries: [String: TypedValue] = [:]
        allKeys.forEach { key in
            let name = key.stringValue
            guard !name.isEmpty else {
                return
            }
            if let value = try? keys.decode(String.self, forKey: key) {
                entries[name] = .string(value)
            } else if let value = try? keys.decode(Bool.self, forKey: key) {
                entries[name] = .bool(value)
            } else if let value = try? keys.decode(Int.self, forKey: key) {
                entries[name] = .int(value)
            } else if let value = try? keys.decode(Double.self, forKey: key) {
                entries[name] = .double(value)
            } else if let value = try? keys.decode(TypedValue.self, forKey: key) {
                entries[name] = value
            }
        }
        return .object(entries)
    }

    private static func decodeSingle(from decoder: Decoder) -> TypedValue? {
        guard let container = try? decoder.singleValueContainer() else {
            return nil
        }
        if let value = try? container.decode(String.self) {
            return .string(value)
        }
        if let value = try? container.decode(Bool.self) {
            return  .bool(value)
        }
        if let value = try? container.decode(Int.self) {
            return .int(value)
        }
        if let value = try? container.decode(Double.self) {
            return .double(value)
        }
        if let value = try? container.decode(TypedValue.self) {
            return value
        }
        return nil
    }

    private static func decodeArray(from decoder: Decoder) -> TypedValue? {
        guard var array = try? decoder.unkeyedContainer(), let count = array.count else {
            return nil
        }
        var data: [TypedValue] = []
        (0..<count).forEach { _ in
            if let value = try? array.decode(String.self) {
                data.append(.string(value))
            } else if let value = try? array.decode(Bool.self) {
                data.append(.bool(value))
            } else if let value = try? array.decode(Int.self) {
                data.append(.int(value))
            } else if let value = try? array.decode(Double.self) {
                data.append(.double(value))
            } else if let value = try? array.decode(TypedValue.self) {
                data.append(value)
            }
        }
        return .array(data)
    }

    private enum Error: Swift.Error {
        case invalidData
    }

    private struct Keys: CodingKey {
        let stringValue: String
        let intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = ""
        }
    }
}
