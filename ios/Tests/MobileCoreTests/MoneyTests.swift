import MobileCore
import XCTest

final class MoneyTests: XCTestCase {
    func testAddsAndSubtractsInCents() {
        XCTAssertEqual(Money(cents: 1_000) + Money(cents: 50), Money(cents: 1_050))
        XCTAssertEqual(Money(cents: 25) - Money(cents: 50), Money(cents: -25))
    }

    func testDollarsConvertToCents() {
        XCTAssertEqual(Money.dollars(123), Money(cents: 12_300))
    }

    func testPercentOfRoundsHalfUp() {
        XCTAssertEqual(Money(cents: 100).percentOf(basisPoints: 550), Money(cents: 6))
        XCTAssertEqual(Money(cents: 100).percentOf(basisPoints: 549), Money(cents: 5))
    }

    func testComparesByCents() {
        XCTAssertTrue(Money(cents: 2) > Money(cents: 1))
        XCTAssertTrue(Money(cents: -1).isNegative)
    }
}
