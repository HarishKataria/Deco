//**************************************************************
//
//  TripleDecodable
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public enum TripleDecodable<FirstType: Decodable, SecondType: Decodable, ThirdType: Decodable>: MultiplexDecodable {
    case first(FirstType)
    case second(SecondType)
    case third(ThirdType)
}

public extension TripleDecodable {
    init?(alternativeValue value: Decodable) {
        if let first = value as? FirstType {
            self = .first(first)
            return
        }
        if let second = value as? SecondType {
            self = .second(second)
            return
        }
        if let third = value as? ThirdType {
            self = .third(third)
            return
        }
        return nil
    }

    static var alternativeTypes: [Decodable.Type] {
        return [FirstType.self, SecondType.self, ThirdType.self]
    }
}
