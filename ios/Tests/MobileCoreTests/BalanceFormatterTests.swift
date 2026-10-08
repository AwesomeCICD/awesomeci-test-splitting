import MobileCore
import XCTest

final class BalanceFormatterTests: XCTestCase {
    func testFormatsWholeAndFractionalDollars() {
        XCTAssertEqual(BalanceFormatter.format(.zero), "$0.00")
        XCTAssertEqual(BalanceFormatter.format(Money(cents: 1_234_567)), "$12,345.67")
    }

    func testGroupsMillions() {
        XCTAssertEqual(BalanceFormatter.format(Money(cents: 100_000_005)), "$1,000,000.05")
    }

    func testFormatsNegativeBalances() {
        XCTAssertEqual(BalanceFormatter.format(Money(cents: -310)), "-$3.10")
    }

    func testMasksIntoBands() {
        XCTAssertEqual(BalanceFormatter.masked(.dollars(999)), "Under $1,000")
        XCTAssertEqual(BalanceFormatter.masked(.dollars(1_000)), "$1,000+")
        XCTAssertEqual(BalanceFormatter.masked(.dollars(250_000)), "$100,000+")
    }
}
