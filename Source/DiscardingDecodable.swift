//**************************************************************
//
//  DiscardingDecodable
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public struct DiscardingDecodable: Decodable {
    public init(from decoder: Decoder) throws {
        //do nothing
    }
}
