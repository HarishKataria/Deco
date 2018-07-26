//**************************************************************
//
//  DoubleDecodable
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public enum DoubleDecodable<FirstType: Decodable, SecondType: Decodable>: MultiplexDecodable {
    case first(FirstType)
    case second(SecondType)
}

public extension DoubleDecodable {
    init?(alternativeValue value: Decodable) {
        if let first = value as? FirstType {
            self = .first(first)
            return
        }
        if let second = value as? SecondType {
            self = .second(second)
            return
        }
        return nil
    }

    static var alternativeTypes: [Decodable.Type] {
        return [FirstType.self, SecondType.self]
    }
}
