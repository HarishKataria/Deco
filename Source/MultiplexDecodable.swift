//**************************************************************
//
//  MultiplexDecodable
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public protocol MultiplexDecodable: Decodable {
    init?(alternativeValue: Decodable)
    static var alternativeTypes: [Decodable.Type] { get }
}

public extension MultiplexDecodable {
    init(from decoder: Decoder) throws {
        let reduceResult: Self? = Self.alternativeTypes.reduce(nil) { last, type in
            guard last == nil,
                let content = try? type.init(from: decoder),
                let instance = Self.init(alternativeValue: content) else { /* swiftlint:disable:this explicit_init */
                    return last
            }
            return instance
        }
        guard let instance = reduceResult else {
            throw MultiplexDecodingError.noDecodableOptionMatched
        }
        self = instance
    }
}

public enum MultiplexDecodingError: Error {
    case noDecodableOptionMatched
}
