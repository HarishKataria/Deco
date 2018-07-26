//**************************************************************
//
//  VerifiableDecodable
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public protocol VerifiableDecodable: Decodable {
    func verifyDecodedState() throws
}

public struct VerifyingDecodable<Wrapped: VerifiableDecodable>: Decodable {
    public let wrapped: Wrapped

    public init(from decoder: Decoder) throws {
        wrapped = try Wrapped.init(from: decoder)
        try wrapped.verifyDecodedState()
    }
}

public struct VerifyingOptionalDecodable<Wrapped: VerifiableDecodable>: Decodable {
    public let wrapped: Wrapped?

    public init(from decoder: Decoder) throws {
        let result: Wrapped?
        do {
            let wrapped = try Wrapped.init(from: decoder)
            try wrapped.verifyDecodedState()
            result = wrapped
        } catch {
            result = nil
        }
        self.wrapped = result
    }
}
