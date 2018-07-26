//**************************************************************
//
//  DecoTest
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Deco

final class DecoTest: XCTestCase {
    private func sample() -> Person {
        return Person(name: "John", addresses: [
            Address(street: "1 Main St.", city: "New York", zipcode: Zipcode(code1: "123", code2: "546")),
            Address(street: "2 Second St.", city: "Chicargo", zipcode: Zipcode(code1: "789", code2: "012"))
            ])
    }

    func testTwinDecodable() throws {
        let sample = self.sample()

        let data1 = try JSONEncoder().encode(sample)
        let data2 = try JSONEncoder().encode(sample.addresses[0])

        let type = DoubleDecodable<Person, Address>.self
        let output1 = try JSONDecoder().decode(type, from: data1)
        let output2 = try JSONDecoder().decode(type, from: data2)

        guard case let .first(value1) = output1,
            case let .second(value2) = output2 else {
                XCTFail("TwoWayDecodable failed")
                return
        }
        XCTAssertEqual(value1.name, "John")
        XCTAssertEqual(value2.city, "New York")
    }

    func testTypedValue() {
        do {
            let d = try JSONEncoder().encode(sample())
            let result = try JSONDecoder().decode(TypedValue.self, from: d)
            /* swiftlint:disable line_length */
            let expected = """
            ["name": "John", "addresses": [["street": "1 Main St.", "city": "New York", "zipcode": ["code2": "546", "code1": "123"]], ["street": "2 Second St.", "city": "Chicargo", "zipcode": ["code2": "012", "code1": "789"]]]]
            """
            /* swiftlint:enable line_length */
            XCTAssertEqual(expected, result.description)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
}

private struct Person: Codable {
    let name: String
    let addresses: [Address]
}

private struct Address: Codable {
    let street: String
    let city: String
    let zipcode: Zipcode
}

private struct Zipcode: Codable {
    let code1: String
    let code2: String
}
